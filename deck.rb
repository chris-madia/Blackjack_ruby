class Deck

  def initialize(number_of_decks = 1)
    @deck = create_deck(number_of_decks)
  end

  def draw(number_of_cards = 1)
    drawn_cards = []
    number_of_cards.times do
      drawn_cards << @deck.pop()
    end
    return drawn_cards
  end

  def size
    @deck.size
  end

  private

  def create_deck(number_of_decks)
    suite = [:Spades, :Clubs, :Hearts, :Diamonds]
    face_value = (2..10).to_a
    face_value << :Jack << :Queen << :King << :Ace

    deck = []

    number_of_decks.times do
      suite.each do |s|
        face_value.each do |v|
          card = Card.new(s, v)
          deck << card
        end
      end
    end

    deck.shuffle!
    return deck
  end
end
