module Idoklad
  module Entities
    class IssuedInvoice < ::Idoklad::Base

      self.entity_name = "IssuedInvoices"

      # Just alias
      def total
        total_with_vat
      end

    end
  end
end
