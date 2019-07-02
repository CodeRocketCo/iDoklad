module Idoklad
  module Entities
    class ApiLimit < ::Idoklad::Base

      self.entity_name = "Test/GetActualApiLimit"

      def self.last
        find(nil)
      end

      def date_of_renewal
        Time.parse(@table[:date_of_renewal]) rescue nil
      end
    end
  end
end
