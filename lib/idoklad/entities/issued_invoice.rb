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

      def status
        self.class.statuses.key(@table[:payment_status])
      end

    end
  end
end
