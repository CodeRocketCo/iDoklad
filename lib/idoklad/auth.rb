require 'oauth2'

module Idoklad
  module Auth

    API_URL = 'https://identity.idoklad.cz'
    AUTHORIZE_URL = '/server/connect/authorize'
    TOKEN_URL = '/server/connect/token'
    SCOPE = 'idoklad_api'

    class << self

      # @return [OAuth2::AccessToken]
      def access_token
        client = OAuth2::Client.new(
          Idoklad.configuration.client_id,
          Idoklad.configuration.client_secret,
          authorize_url: AUTHORIZE_URL,
          token_url: TOKEN_URL,
          site: API_URL
        )

        client.client_credentials.get_token(scope: SCOPE)
      end

      # Cache access_token (for performance optimisation & multi-tenancy solution) and handle it expiration
      # @return [String]
      def bearer_token
        @tokens ||= {}
        token = @tokens[cache_key] ||= access_token
        token = @tokens[cache_key] = access_token if token.expired?
        token.token
      end

      private

      def cache_key
        "#{Idoklad.configuration.client_id}_#{Idoklad.configuration.client_secret}"
      end
    end
    # Backward compatibility
    def self.get_token
      bearer_token
    end

  end
end
