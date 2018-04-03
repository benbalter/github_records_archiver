module GitHubRecordsArchiver
  class CLI < Thor
    package_name 'GitHub Records Archiver'
    class_option :dest_dir, type: :string, required: false,
                            desc: 'The destination directory for the archive', default: GitHubRecordsArchiver.dest_dir
    class_option :token, type: :string, required: false, desc: 'A GitHub personal access token with repo scope'
    class_option :verbose, type: :boolean, desc: 'Display verbose output while archiving', default: false

    desc 'version', 'Outputs the GitHubRecordsArchiver version'
    def version
      say "GitHub Records Archiver v#{GitHubRecordsArchiver::VERSION}"
    end

    desc 'delete [ORGANIZATION]', 'Deletes all archives, or the archive for an organization'
    option :force, type: :boolean, desc: 'Delete without prompting', default: false
    def delete(org_name = nil)
      path = GitHubRecordsArchiver.dest_dir
      path = File.join path, org_name if org_name
      FileUtils.rm_rf(path) if options[:force] || yes?("Are you sure? Remove #{path}?")
    end

    desc 'archive ORGANIZATION', 'Create or update archive for the given organization'
    option :migration, type: :boolean, default: false,
                       desc: 'Exports data via the migration API. See https://git.io/vx1I1'
    def archive(org_name)
      start_time # Memoize start time for comparison
      @org_name = org_name

      GitHubRecordsArchiver.shell = shell
      %i[token dest_dir verbose].each do |option|
        next unless options[option]
        GitHubRecordsArchiver.public_send "#{option}=".to_sym, options[option]
      end

      say "Starting archive for @#{org.name} in #{org.archive_dir}"
      shell.indent(2) do
        archive_teams
        archive_repos
        archive_migration if options[:migration]
      end
      say "Done in #{Time.now - start_time} seconds.", :green
    end

    private

    def start_time
      @start_time ||= Time.now
    end

    def organization
      @organization ||= GitHubRecordsArchiver::Organization.new @org_name
    end
    alias org organization

    def archive_teams
      say_status 'Teams found:', org.teams.count, :white
      Parallel.each(org.teams, progress: 'Archiving teams', &:archive)
    end

    def archive_repos
      say_status 'Repositories found:', org.repos.count, :white

      Parallel.each(org.repos, progress: 'Archiving repos') do |repo|
        begin
          repo.clone
          repo.wiki.clone if repo.has_wiki?
          Parallel.each(repo.issues, &:archive)
        rescue GitHubRecordsArchiver::GitError => e
          say "Failed to archive #{repo.name}", :red
          say e.message, :red
        end
      end
    end

    def migration
      @migration ||= Migration.new(organization)
    end

    def archive_migration
      migration.start
      state = nil
      retries = 0
      while state != 'exported' && state != 'failed'
        state = migration.state
        if state != 'exported' && state != 'failed'
          sleep_time = (2**retries)
          msg = "#{state} (checking again in #{sleep_time} second#{'s' if sleep_time != 1})"
          say_status 'Migration status:', msg, :white
          sleep sleep_time
          retries += 1
        elsif state == 'exported'
          say_status 'Migration status:', state.to_s, :green
        elsif state == 'failed'
          say_status 'Migration status:', state.to_s, :red
        end
      end
      say_status 'Migration URL:', migration.url, :green
    end
  end
end
