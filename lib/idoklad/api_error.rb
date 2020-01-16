module Idoklad
  class ApiError < IdokladError

    # @return [RestClient::Response]
    attr_reader :response
    # @return [Hash]
    attr_reader :response_body

    # @param [RestClient::Response] response
    def initialize(response)
      @response = response
      @response_body = Idoklad::ApiRequest.parse_response(response)
      super @response_body["Message"]
    end

    def code
      @response.code
    end
  end

end
