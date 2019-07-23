module Idoklad
  class Base < OpenStruct

    class Table < Hash
      def key?(name)
        super || super(camelcase(name.to_s))
      end

      def [](name)
        super || super(camelcase(name.to_s))
      end

      def []=(name, value)
        super(camelcase(name.to_s), value)
      end

      private

      # Convert attribute name to underscore
      def underscore(string)
        word = string.to_s.dup
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
        word.downcase!
        word
      end

      def camelcase(string)
        string.sub(/^[a-z\d]*/) { |match| match.capitalize }.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::").to_sym
      end
    end

    class << self

      # @param [String] arg
      def entity_name=(arg)
        @entity_name = arg
      end

      # @return [String]
      def entity_name
        @entity_name
      end

      # Empty entity with default values. Ideal for creation new entity
      def default
        find("Default")
      end

      # @param [String] id
      def find(id)
        json = parse_response Idoklad::ApiRequest.get "#{path}/#{id}"
        raise ::Idoklad::EntityNotFound if json.nil? || json.empty?

        new(json)
      end

      def first
        where(page_size: 1).first
      end

      # Alias for "all" entities
      # @todo deal with pagination
      def all
        where
      end

      # @param [Hash] params
      # @option params (see Idoklad::ParamsParser#initialize)
      # @see https://app.idoklad.cz/developer/Help
      def where(**params)
        unknown_keys = params.keys - %i[filter sort page_size page filtertype]
        raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(', ')}") unless unknown_keys.empty?

        request_path = path
        params = ParamsParser.new params

        response = Idoklad::ApiRequest.get("#{request_path}?#{params}")
        parse_response(response)&.fetch("Data", []).collect(&method(:new))
      end

      # @param [Hash] filter
      # @example find entity by specify attribute(s)
      #   find_by(DocumentNumber: "1234") # => <IssuedInvoice DocumentNumber="123">
      def find_by(**filter)
        raise ArgumentError if filter.empty?

        where(filter: filter).first
      end

      # @param [Net::HTTPResponse] response
      def parse_response(response)
        JSON.parse response.body
      rescue JSON::ParserError => ex
        puts ex.message
        puts <<~EOF
          Response:
              status: #{response.code};
              body: #{response.body};
              headers: #{response.header}
        EOF
        {}
      end

      def path
        "/developer/api/v2/#{entity_name}"
      end

    end

    attr_reader :errors

    # @param [Hash] hash
    def initialize(hash)
      @table = Table.new
      hash.each_pair do |k, v|
        @table[k.to_sym] = v
      end
      @errors = []
    end

    def path
      self.class.path
    end

    def save
      if id.nil? || id.zero?
        @response = Idoklad::ApiRequest.post(path, @table)
        body = parse_response(@response)
        if @response.is_a? Net::HTTPOK
          body.each_pair do |k, v|
            @table[k.to_sym] = v
          end
          true
        else
          @errors = body
          false
        end
      else
        raise NotImplementedError
      end
    end

    def destroy
      response = Idoklad::ApiRequest.delete("#{path}/#{id}")
      raise ::Idoklad::EntityNotFound, response.body if response.is_a? Net::HTTPNotFound

      response.is_a? Net::HTTPOK
    end

    private

    def parse_response(response)
      self.class.parse_response(response)
    end

  end
end
