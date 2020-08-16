# :nocov:
module Idoklad
  # @deprecated Use {Idoklad::Entities::IssuedInvoice} instead.
  class IssuedInvoices

    class << self
      def get_list
        puts "Use Idoklad::Entities::IssuedInvoice#all instead"
        raise NotImplementedError

        #response = Idoklad::ApiRequest.get '/developer/api/v2/IssuedInvoices'
        #
        #JSON.parse response.body
      end

      def get_default
        puts "Use Idoklad::Entities::IssuedInvoice.default instead"
        raise NotImplementedError
        #response = Idoklad::ApiRequest.get '/developer/api/v2/IssuedInvoices/Default'
        #
        #JSON.parse response.body
      end

      def create(invoice)
        puts "Use Idoklad::Entities::IssuedInvoice#create instead"
        raise NotImplementedError

          #response = Idoklad::ApiRequest.post '/developer/api/v2/IssuedInvoices', invoice
          #
          #JSON.parse response.body
      end
    end

  end
end
# :nocov:
