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
      @repo_dir ||= File.join repository.repo_dir, 'wiki'
    end

    private

    def clone_url
      @clone_url ||= repository.clone_url.gsub(/\.git\z/, '.wiki.git')
    end
  end
end
