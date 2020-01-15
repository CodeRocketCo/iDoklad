module Idoklad
  class ApiError < IdokladError

    # @return [RestClient::Response]
    attr_reader :response
    # @return [Hash]
    attr_reader :body

    # @param [RestClient::Response] response
    def initialize(response)
      @response = response
      @body = Idoklad::ApiRequest.parse_response(response)
      super @body["Message"]
    end

    def code
      @response.code
    end
  end

end
