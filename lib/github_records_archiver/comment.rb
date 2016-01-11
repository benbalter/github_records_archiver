module GitHubRecordsArchiver
  class Comment
    attr_reader :repository
    attr_reader :id

    include DataHelper

    def initialize(repo, id)
      repo = Repository.new(repo) if repo.is_a? String
      @repository = repo
      @id = id
    end

    def self.from_hash(repo, hash)
      comment = Comment.new(repo, hash[:number])
      comment.instance_variable_set '@data', hash.to_h
      comment
    end

    def data
      @data ||= begin
        GitHubRecordsArchiver.client.issue_comment(repository.full_name, number)
      end
    end

    def to_s
      output = "@#{user[:login]} at #{created_at} wrote:\n\n"
      output << body
      output
    end

    def to_json
      data.to_json
    end
  end
end
