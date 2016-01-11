module GitHubRecordsArchiver
  class User
    attr_reader :login
    alias_method :name, :login

    KEYS = [:login, :site_admin, :type]

    def initialize(login_or_hash)
      if login_or_hash.is_a? String
        @login = login_or_hash
      else
        @login = login_or_hash[:login]
        @data = login_or_hash.to_h
      end
    end

    def data
      @data ||= GitHubRecordsArchiver.client.user login
    end
  end
end
