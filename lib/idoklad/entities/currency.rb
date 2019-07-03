module Idoklad
  module Entities
    class Currency < ::Idoklad::Base

      self.entity_name = "Currencies"

      def to_s
        @table[:symbol]
      end
    end
  end
end
