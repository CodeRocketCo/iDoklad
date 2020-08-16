module Idoklad
  module Entities
    class NumericSequences < ::Idoklad::Base

      self.entity_name = "NumericSequences"

      def self.document_types
        {
          issued_invoice: 0,
          proforma_invoice: 1,
          cash_voucher: 2,
          credit_note: 3,
          bank_statement: 4,
          received_invoice: 5,
          sales_receipt: 6,
          sales_order: 7,
          internal_document: 9
        }
      end

      def document_type
        self.class.document_types.key @table["DocumentType"]
      end

      def document_type=(arg)
        arg = self.class.document_types[arg.underscore.to_sym] unless arg.to_s =~ /\d/
        self.attributes = { "DocumentType" => arg.to_i }
      end

    end
  end
end
