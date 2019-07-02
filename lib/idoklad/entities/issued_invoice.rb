module Idoklad
  module Entities
    class IssuedInvoice < ::Idoklad::Base

      self.entity_name = "IssuedInvoices"

      # Just alias
      def total
        @table[:total_with_vat]
      end

      def number
        @table[:document_number]
      end

      def currency
        Currency.find(@table[:currency_id])
      end

    end
  end
end
