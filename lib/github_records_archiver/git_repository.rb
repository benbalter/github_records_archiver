module GitHubRecordsArchiver
  class GitError < StandardError; end

  class GitRepository
    def clone
      # Repo already exists, just pull new objects
      if Dir.exist? File.join(repo_dir, '.git')
        Dir.chdir repo_dir do
          git 'pull'
        end
      else
        # Clone Git content from scratch
        git 'clone', clone_url, repo_dir
      end
    end

    def repo_dir
      raise 'Not implemented'
    end

    private

    def clone_url
      raise 'Not implemented'
    end

    # There's a bug, whereby if you attempt to clone a wiki that's enabled
    # but has not yet been initialized, GitHub returns a remote error
    # Rather than let this break the export, capture the error and continue
    def wiki_does_not_exist?(output)
      expected = '^fatal: remote error: access denied or repository not '
      expected << "exported: .*?\.wiki\.git$"
      output =~ /#{expected}/
    end

    # Attempting to clone an empty repo will rightfulyl fail at the Git level
    # But we shouldn't let that fail the archive operation
    def empty_repo?(output)
      expected = 'Your configuration specifies to merge with the ref '
      expected << "'refs/heads/master'\n"
      expected << 'from the remote, but no such ref was fetched.'
      output =~ Regexp.new(expected)
    end

    # Run a git command, piping output to stdout
    def git(*args)
      output, status = Open3.capture2e('git', *args)
      cmd = "git #{args.join(' ')}"
      cmd << " in #{Dir.pwd}" if args == ['pull']
      GitHubRecordsArchiver.verbose_status 'Git command:', cmd
      return false if empty_repo?(output) || wiki_does_not_exist?(output)
      if status.exitstatus != 0
        output = GitHubRecordsArchiver.remove_token(output)
        GitHubRecordsArchiver.shell.say_status 'Git Error', output, :red
      end
      output
    end
  end
end
