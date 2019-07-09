module Idoklad
  class Base < OpenStruct

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
        new(json) if json
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
        unknown_keys = params.keys - %i[filter sort pagesize page filtertype]
        raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(', ')}") unless unknown_keys.empty?

        request_path = path
        params = ParamsParser.new params

        parse_response(Idoklad::ApiRequest.get("#{request_path}?#{params}"))&.fetch("Data", []).collect(&method(:new))
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
      rescue JSON::ParserError
        nil
      end

      def path
        "/developer/api/v2/#{entity_name}"
      end

    end

    # @param [Hash] hash
    def initialize(hash)
      @table = {}
      hash.each_pair do |k, v|
        k = attribute_name(k).to_sym
        @table[k] = v
      end
    end

    private

    # Convert attribute name to underscore
    def attribute_name(arg)
      word = arg.to_s.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word.downcase!
      word
    end

  end
end
