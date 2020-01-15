require 'rest-client'

module Idoklad
  module ApiRequest

    class << self

      def delete(path)
        response = RestClient.delete("#{Idoklad::API_URL}#{path}", authorization)
        parse_response(response)
      rescue RestClient::ExceptionWithResponse => e
        raise ApiError, e.response
      end

      def get(path)
        response = RestClient.get("#{Idoklad::API_URL}#{path}", authorization)
        parse_response(response)
      rescue RestClient::ExceptionWithResponse => e
        raise ApiError, e.response
      end

      def post(path, object)
        headers = { content_type: :json }.merge(authorization)
        response = RestClient.post("#{Idoklad::API_URL}#{path}", JSON.generate(object), headers)
        parse_response(response)
      rescue RestClient::ExceptionWithResponse => e
        raise ApiError, e.response
      end

      # Parse response object to JSON
      # @note in case of parse error return Hash compatible with iDoklad error response
      # @param [RestClient::Response] response
      # @return [Hash]
      def parse_response(response)
        JSON.parse response.body
      rescue JSON::ParserError => ex
        puts ex.message
        puts <<~EOF
          Response:
              status: #{response.code};
              body: #{response.body};
              headers: #{response.headers}
        EOF
        { Data: response.body, Message: ex.message, StatusCode: response.code, Headers: response.headers }
      end

      private

      def authorization
        { Authorization: "Bearer #{Idoklad::Auth.get_token}" }
      end

    end

  end
end
