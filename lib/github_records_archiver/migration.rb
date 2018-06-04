module GitHubRecordsArchiver
  class Migration
    OCTOKIT_OPTIONS = {
      accept: 'application/vnd.github.wyandotte-preview+json'
    }.freeze

    include DataHelper
    attr_reader :organization, :lock_repositories

    def initialize(organization, id: nil, lock_repositories: false)
      organization = Organization.new(organization) if organization.is_a? String
      @organization = organization
      @id = id
      @lock_repositories = lock_repositories
    end

    def id
      @id ||= data['id']
    end

    def start
      options = OCTOKIT_OPTIONS.merge(lock_repositories: lock_repositories)
      @data = GitHubRecordsArchiver.client.start_migration(
        organization.name, repository_names, options
      )
      @id = @data['id']
      @data
    end

    def state
      data(force: true)['state']
    end

    def url
      @url ||= GitHubRecordsArchiver.client.migration_archive_url(
        organization.name, id, OCTOKIT_OPTIONS
      )
    end

    def delete
      GitHubRecordsArchiver.client.delete_migration_archive(
        organization.name, id, OCTOKIT_OPTIONS.dup
      )
    end

    def data(force: false)
      @data = nil if force
      @data ||= GitHubRecordsArchiver.client.migration_status(
        organization.name, id, OCTOKIT_OPTIONS
      )
    end

    private

    def repository_names
      @repository_names ||= organization.repositories.map(&:full_name)
    end
  end
end
