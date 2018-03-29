module GitHubRecordsArchiver
  class Organization
    attr_reader :name

    include DataHelper

    def initialize(name)
      @name = name
    end

    def data
      @data ||= GitHubRecordsArchiver.client.organization name
    end

    def repositories
      @repositories ||= begin
        repos = GitHubRecordsArchiver.client.organization_repositories(name)
        repos.map { |hash| Repository.new(hash) }
      end
    end
    alias repos repositories

    def teams
      @teams ||= begin
        teams = GitHubRecordsArchiver.client.organization_teams(name)
        teams.map { |h| Team.from_hash(self, h) }
      rescue Octokit::Forbidden
        []
      end
    end

    private

    def archive_dir
      @archive_dir ||= begin
        dir = File.expand_path name, GitHubRecordsArchiver.dest_dir
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        dir
      end
    end

    def teams_dir
      @teams_dir ||= begin
        dir = File.expand_path 'teams', archive_dir
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        dir
      end
    end
  end
end
