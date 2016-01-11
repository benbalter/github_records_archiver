module GitHubRecordsArchiver
  class Team
    attr_reader :id
    attr_reader :organization

    include DataHelper

    KEYS = [:name, :slug, :description, :privacy, :permission]

    def initialize(org, id)
      org = Organization.new(org) if org.is_a? String
      @organization = org
      @id = id
    end

    def self.from_hash(org, hash)
      team = Team.new(org, hash[:id])
      team.instance_variable_set '@data', hash.to_h
      team
    end

    def data
      @data ||= GitHubRecordsArchiver.client.team id
    end

    def repositories
      @repositories ||= begin
        repos = GitHubRecordsArchiver.client.team_repositories id
        repos.map { |r| Repository.new(r) }
      end
    end

    def members
      @members ||= begin
        members = GitHubRecordsArchiver.client.team_members id
        members.map { |m| User.new(m) }
      end
    end

    def archive
      File.write(path, to_s)
    end

    def path
      File.expand_path "#{data[:slug]}.md", organization.teams_dir
    end

    def to_s
      meta_for_markdown.to_yaml
    end

    def to_json
      data.merge(reopsitories: repositories.map(&:name)).to_json
    end

    private

    def meta_for_markdown
      meta = {}
      KEYS.each { |key| meta[key.to_s] = data[key] }
      meta['repositories'] = repositories.map(&:name)
      meta['members'] = members.map(&:name)
      meta
    end
  end
end
