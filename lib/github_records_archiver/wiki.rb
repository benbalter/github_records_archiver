module GitHubRecordsArchiver
  class Wiki < GitRepository
    attr_accessor :repository

    def initialize(repository)
      if repository.is_a?(String)
        @repository = Repository.new(repository)
      else
        @repository = repository
      end
    end

    def repo_dir
      name = "#{repository.data[:full_name]}/wiki"
      @repo_dir ||= File.expand_path name, GitHubRecordsArchiver.dest_dir
    end

    private

    def clone_url
      replacement = "https://#{GitHubRecordsArchiver.token}:x-oauth-basic@"
      url = @repository.data[:clone_url].gsub(%r{https://}, replacement)
      url.gsub('.git', '.wiki.git')
    end
  end
end
