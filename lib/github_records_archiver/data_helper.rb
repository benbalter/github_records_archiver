module GitHubRecordsArchiver
  module DataHelper
    attr_writer :data

    def method_missing(method_sym, *arguments, &block)
      return data[method_sym] if data_key?(method_sym)
      if method_sym.to_s.end_with? '?'
        !send(non_predicate_method(method_sym)).to_s.empty?
      else
        super
      end
    end

    def respond_to_missing?(method_sym, include_private = false)
      if data_key? non_predicate_method(method_sym)
        true
      else
        super
      end
    end

    def to_h
      data.to_h
    end
    alias as_json to_h

    def to_json
      as_json.to_json
    end

    def data
      raise 'Not implemented'
    end

    private

    def data_key?(key)
      data && data.key?(key)
    end

    def non_predicate_method(method_sym)
      method_sym.to_s.gsub(/\?\z/, '').to_sym
    end
  end
end
