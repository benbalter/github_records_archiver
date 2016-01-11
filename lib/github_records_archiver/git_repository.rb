module GitHubRecordsArchiver
  class GitRepository
    def clone
      if Dir.exist? repo_dir # Repo already exists, just pull new objects
        Dir.chdir repo_dir
        GitHubRecordsArchiver.git 'pull'
      else # Clone Git content from scratch
        GitHubRecordsArchiver.git 'clone', clone_url, repo_dir
      end
    end

    def repo_dir
      fail 'Not implemented'
    end

    private

    def clone_url
      fail 'Not implemented'
    end
  end
end
