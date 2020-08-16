module Idoklad
  module Entities
    class Contact < ::Idoklad::Base

      self.entity_name = "Contacts"

      def dic
        @table["VatIdentificationNumber"]
      end

      def ico
        @table["IdentificationNumber"]
      end
      alias ic ico

      def name
        @table["CompanyName"]
      end

      def name=(company_name)
        @table["CompanyName"] = company_name
      end

    end
  end
end
