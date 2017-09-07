class Card

      def initialize(suit, face_value)
        @suit = suit
        @face_value = face_value
      end

      def get_value
        card_value = [@suit, @face_value]
      end
    end
