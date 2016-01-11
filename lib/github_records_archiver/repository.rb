module GitHubRecordsArchiver
  class Repository < GitRepository
    attr_accessor :name

    KEYS = [:name, :full_name, :description, :private, :fork, :homepage, :forks_count, :stargazers_count, :watchers_count, :size]

    def initialize(name_or_hash)
      if name_or_hash.is_a?(String)
        @name = name
      else
        @data = name_or_hash.to_h
        @name = data[:full_name]
      end
    end

    def data
      @data ||= GitHubRecordsArchiver.client.repository(name)
    end

    def repo_dir
      @repo_dir ||= File.expand_path name, GitHubRecordsArchiver.dest_dir
    end

    def issues_dir
      @issues_dir ||= begin
        dir = File.expand_path 'issues', repo_dir
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        dir
      end
    end

    def wiki
      @wiki ||= Wiki.new(self) if data[:has_wiki]
    end

    def issues
      @issues ||= begin
        issues = GitHubRecordsArchiver.client.list_issues name, state: 'all'
        issues.map { |i| Issue.from_hash(self, i) }
      end
    end

    private

    def clone_url
      replacement = "https://#{GitHubRecordsArchiver.token}:x-oauth-basic@"
      data[:clone_url].gsub(%r{https?://}, replacement)
    end
  end
end
