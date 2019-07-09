module Idoklad
  # Parse input params to iDoklad API parameter
  class ParamsParser

    # @param [Hash] hash
    # @option hash [String] :filter
    # @option hash [String] :sort (id~asc)
    # @option hash [Integer] :pagesize
    # @option hash [Integer] :page
    # @option hash [Integer] :filtertype (and) it can be `and` or `or`
    def initialize(**hash)
      @source = hash
    end

    def to_s
      to_param = {
        filter: filter,
        sort: sort,
        pagesize: page_size,
        page: page,
        filtertype: filter_type
      }.delete_if { |_, v| v.nil? || v.empty? }.collect { |k, v| "#{k}=#{v}" }
      to_param.join("&")
    end

    # @example input of sort
    #   { sort: "-DocumentNumber"}
    # @example output of sort
    #   DocumentNumber~desc
    # @return [String]
    def sort
      sort = @source[:sort]
      return unless sort

      order = if sort.start_with?("-") || sort.start_with?("!")
                sort.delete!("-!")
                "desc"
              else
                "asc"
              end
      "#{sort}~#{order}"
    end

    # @example output of filter
    #   DocumentNumber~eq~1234
    # @return [String]
    def filter
      data = @source[:filter] || {}
      return data if data.is_a? String
      raise ArgumentError, "#{data} is not String or Hash - I dont know what to do" unless data.is_a? Hash

      data.collect { |k, v| [k, operator(v), v].join("~") }.join("|")
    end

    # @return [String]
    def page_size

    end

    # @return [String]
    def page

    end

    # filtertype @see https://app.idoklad.cz/Developer/Help
    # @return [String]
    def filter_type
      @source[:filtertype]
    end

    private

    def operator(value)
      "eq"
    end

  end
end
