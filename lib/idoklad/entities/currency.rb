module Idoklad
  module Entities
    class Currency < ::Idoklad::Base

      self.entity_name = "Currencies"

      def to_s
        @table["Symbol"]
      end
    end
  end
end
