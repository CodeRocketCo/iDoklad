module Idoklad
  class IssuedInvoices

    class << self
      def get_list
        response = Idoklad::ApiRequest.get '/developer/api/v2/IssuedInvoices'

        JSON.parse response.body
      end

      def get_default
        response = Idoklad::ApiRequest.get '/developer/api/v2/IssuedInvoices/Default'

        JSON.parse response.body
      end

      def create(invoice)
        response = Idoklad::ApiRequest.post '/developer/api/v2/IssuedInvoices', invoice

        JSON.parse response.body
      end
    end

  end
end
