module GitHubRecordsArchiver
  class Wiki < GitRepository
    attr_accessor :repository

    include DataHelper

    def initialize(repository)
      @repository = if repository.is_a?(String)
                      Repository.new(repository)
                    else
                      repository
                    end
    end

    def repo_dir
      name = "#{repository.full_name}/wiki"
      @repo_dir ||= File.expand_path name, GitHubRecordsArchiver.dest_dir
    end

    private

    def clone_url
      @clone_url ||= repository.clone_url.gsub(/\.git\z/, '.wiki.git')
    end
  end
end
