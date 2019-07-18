module Idoklad
  module ApiRequest

    class << self
      def get(path)
        uri = URI.parse("#{Idoklad::API_URL}#{path}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.get(uri.request_uri, 'Authorization' => "Bearer #{Idoklad::Auth.get_token}")
      end

      def post(path, object)
        uri = URI.parse("#{Idoklad::API_URL}#{path}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.post(uri.request_uri, JSON.generate(object), 'Authorization' => "Bearer #{Idoklad::Auth.get_token}", 'Content-type' => 'application/json')
      end
    end

  end
end
