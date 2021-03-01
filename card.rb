class Card
  attr_reader :suit, :value, :card

  SUIT_VALUES = ['C', 'D', 'H', 'S']
  CARD_VALUES = {
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14,
  }
  CARD_NAMES = {
    10 => "Ten",
    11 => "Jack",
    12 => "Queen",
    13 => "King",
    14 => "Ace"
  }

  SUIT_NAMES = {
    'C' => 'Clubs',
    'D' => 'Daimond',
    'H' => 'Harts',
    'S' => 'Spades'
  }
  
  def compare(otherCard)
    @value==otherCard.value ? 0 : @value < otherCard.value ? -1 : 1
  end

  def showCard
    "#{CARD_NAMES[@value] || @value} of #{SUIT_NAMES[@suit]}"
  end

  def initialize(c)
    @card = c.upcase
    @value = CARD_VALUES[@card[0]] || @card[0].to_i
    @suit = @card[1]
    raise "Invalid suit #{@suit}!" unless SUIT_VALUES.include?(@suit)
    raise "Invalid value #{@value}!" unless 2.upto(14).to_a.include?(@value)
  end
end