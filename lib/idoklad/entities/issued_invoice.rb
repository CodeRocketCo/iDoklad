module Idoklad
  module Entities
    class IssuedInvoice < ::Idoklad::Base

      self.entity_name = "IssuedInvoices"

      # Just alias
      def total
        prices["TotalWithVat"]
      end

      def number
        @table["DocumentNumber"]
      end

      def currency
        return @currency if defined? @currency

        @currency ||= Currency.find(@table["CurrencyId"])
      end

      # @param [Idoklad::Entities::IssuedInvoice::Currency, String, Nil] arg can be eur,czk.. or Currency object
      def currency=(arg)
        @currency = arg
        if arg.is_a?(Currency)
          @table["CurrencyId"] = arg.id
        else
          @currency = Currency.find_by(code: arg) if arg
          @table["CurrencyId"] = @currency&.id
        end
        currency
      end

      def partner
        return @partner if defined? @partner

        @partner ||= Contact.find(@table["PartnerId"]) if @table["PartnerId"].to_i.positive?
      end

      alias contact partner

      def partner=(arg)
        raise ArgumentError if arg && !arg.is_a?(Idoklad::Entities::Contact)

        @partner = arg
      end

      alias contact= partner=

      def contact_id
        @table["PartnerId"]
      end

      def contact_id=(arg)
        remove_instance_variable :@partner if instance_variable_defined?(:@partner)
        @table["PartnerId"] = arg
      end
      alias partner_id= contact_id=

      def self.statuses
        {
          unpaid: 0,
          paid: 1,
          partial_paid: 2,
          overpaid: 3
        }
      end

      statuses.keys.each do |s|
        define_method :"#{s}?" do
          status == s
        end
      end

      # @return [Symbol]
      def status
        self.class.statuses.key(@table["PaymentStatus"])
      end

      def status=(_)
        raise NoMethodError
      end

      private

      def prices
        @table["Prices"] || {}
      end

    end
  end
end
