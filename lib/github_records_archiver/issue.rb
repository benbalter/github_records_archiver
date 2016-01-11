module GitHubRecordsArchiver
  class Issue
    attr_accessor :repository
    attr_accessor :number

    KEYS = [:title, :number, :state, :html_url, :created_at, :closed_at]

    def initialize(repository: nil, number: nil)
      repository = Repository.new(repository) if repository.is_a? String
      @repository = repository
      @number = number
    end

    def self.from_hash(repo, hash)
      issue = Issue.new(repository: repo, number: hash[:number])
      issue.instance_variable_set('@data', hash.to_h)
      issue
    end

    def data
      @data ||= GitHubRecordsArchiver.client.issue repository.name, number
    end
    alias_method :to_h, :data

    def comments
      @comments ||= begin
        return [] if @data['comments'] == 0
        client = GitHubRecordsArchiver.client
        comments = client.issue_comments repository.data[:full_name], number
        comments.map { |hash| Comment.from_hash(repository, hash) }
      end
    end

    def path(ext = 'md')
      File.expand_path "#{number}.#{ext}", repository.issues_dir
    end

    def to_s
      md = meta_for_markdown.to_yaml
      md << "---\n\n"
      md << "# #{data[:title]}\n\n"
      md << data[:body] if data[:body]
      unless comments.nil?
        md << "\n\n---\n"
        md << comments.map(&:to_s).join("\n\n---\n")
      end
      md
    end

    def to_json
      data.to_h.merge('comments' => comments.map(&:to_json)).to_json
    end

    def archive
      File.write(path('md'), to_s)
      File.write(path('json'), to_json)
    end

    private

    def meta_for_markdown
      meta = {}
      KEYS.each { |key| meta[key.to_s] = data[key] }
      meta['user']     = data[:user][:login]
      meta['assignee'] = data[:assignee][:login] if data[:assignee]
      meta['tags']     = data[:labels].map { |tag| tag[:name] }
      meta
    end
  end
end
