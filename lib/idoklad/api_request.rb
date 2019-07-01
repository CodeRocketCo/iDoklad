module Idoklad
  module ApiRequest

    def self.get(path)
      @token ||= Idoklad::Auth.get_token

      uri = URI.parse("#{Idoklad::API_URL}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.get(uri.request_uri, { 'Authorization' => "Bearer #{@token}" })
    end

    def self.post(path, object)
      @token ||= Idoklad::Auth.get_token

      uri = URI.parse("#{Idoklad::API_URL}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.post(uri.request_uri, JSON.generate(object), { 'Authorization' => "Bearer #{@token}", 'Content-type' => 'application/json' })
    end

  end
end
