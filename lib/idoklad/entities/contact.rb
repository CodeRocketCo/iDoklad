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

      def name
        @table["CompanyName"]
      end

      def name=(company_name)
        @table["CompanyName"] = company_name
      end

      def updated_at
        Time.parse(@table["DateLastChange"])
      rescue ArgumentError
        # nil
      end

    end
  end
end
