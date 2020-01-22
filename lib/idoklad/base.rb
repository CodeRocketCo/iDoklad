require 'active_support'
require 'active_support/core_ext/string'

module Idoklad
  class Base < OpenStruct

    # Virtual table of attributes with fallback to CamelCase strings
    # @note data are stored in Strings (CamelCase) primary
    class Table < Hash
      def key?(name)
        super || super(name.to_s.camelcase)
      end

      # @param [String, Symbol] name
      def [](name)
        super || super(name.to_s.camelcase)
      end

      # @param [String, Symbol] name
      # @param [Object] value
      def []=(name, value)
        if name.is_a?(Symbol)
          super(name.to_s.camelcase, value)
        else
          super(name.camelcase, value)
        end
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
        json = Idoklad::ApiRequest.get "#{path}/#{id}"
        raise StandardError unless json

        new(json["Data"])
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


        response = Idoklad::ApiRequest.get("#{request_path}?#{params}")["Data"] || {}
        (response["Items"] || []).collect(&method(:new))
      end

      # @param [Hash] filter
      # @example find entity by specify attribute(s)
      #   find_by(DocumentNumber: "1234") # => <IssuedInvoice DocumentNumber="123">
      def find_by(**filter)
        raise ArgumentError if filter.empty?

        where(filter: filter).first
      end

      def path
        "/#{entity_name}"
      end

    end

    attr_reader :errors

    # @param [Hash] json
    def initialize(json)
      @table = Table.new
      json.each_pair do |k, v|
        @table[k] = v
      end
      @errors = []
    end

    # @!group Attributes

    def attributes
      @table
    end

    # Reassign json (hash) to Table
    def attributes=(json = {})
      json.each_pair do |k, v|
        @table[k] = v
      end
    end

    # @return [Integer]
    def id
      @table["Id"]
    end

    # @return [Time]
    def updated_at
      Time.parse(metadata["DateLastChange"])
    rescue ArgumentError
      # nil
    end

    # @return [Time]
    def created_at
      Time.parse(metadata["DateCreated"])
    rescue ArgumentError
      # nil
    end

    # @!group Actions

    # @return [Boolean]
    def save
      begin
        if id.nil? || id.zero?
          self.attributes = Idoklad::ApiRequest.post(path, @table)["Data"]
          true
        else
          self.attributes = Idoklad::ApiRequest.patch(path, attributes)
          true
        end
      rescue ApiError => e
        @errors = Array(e.message)
        false
      end
    end

    def update(attributes = {})
      self.attributes = Idoklad::ApiRequest.patch("#{path}/#{id}", attributes)
      self
    end

    def destroy
      response = Idoklad::ApiRequest.delete("#{path}/#{id}")
      response["IsSuccess"]
    end

    # @!endgroup

    def path
      self.class.path
    end

    private

    def metadata
      @table["Metadata"]
    end

    #def method_missing(m, *args, &block)
    #  attribute = m.is_a?(Symbol) && m.to_s || m
    #  if @table.key?(attribute.camelcase)
    #    @table[attribute]
    #  else
    #    raise ArgumentError.new("Method `#{m}` doesn't exist.")
    #  end
    #end

  end
end
