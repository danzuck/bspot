require './card'

class Hand
  attr_reader :value, :cards, :pairs, :hand

  DEBUG = false

  HAND_VALUES = {
    0   => 'High Card',
    100 => 'Pair',
    101 => 'Two Pair',
    102 => 'Three of a Kind',
    103 => 'Straight',
    104 => 'Flush',
    105 => 'Full House',
    106 => 'Four of a Kind',
    107 => 'Straight Flush',
    108 => 'Royal Flush'
  }
  
  def showCards
    sprintf("%15s", @cards.collect{|c| c.card}.join(' '))
  end

  def showHand
    sprintf("%16s %s", hand, showCards)
  end

  def flush?
    @cards.map{|c| c.suit}.uniq.size==1
  end

  def straight?
    lastv = 0
    str = true
    @cards.map{|c| c.value}.sort.each do |val| 
      if lastv > 0 && val != lastv + 1
        str=false
      end
      lastv=val
    end
    str
  end

  #Must be a flush and straight, if highest is Ace we good.
  def royalFlush?
    return false unless flush?
    return false unless straight?
    return false unless  cards.map{|c| c.value}.sort.reverse[0] == Card::CARD_VALUES['A']
    true
  end

  def compare(otherHand)
    if @value == otherHand.value
      winner = tieBreaker(otherHand)
    else
      winner = @value > otherHand.value ? 1 : -1
    end

    debug "#{showHand}   <-->  #{otherHand.showHand}  WINNER: #{winner==1 ? 'Left' : winner==-1 ? 'Right' : 'Tie'}"
    winner
  end
  
  private

  def initialize(cards)
    @cards = []
    @pairs = Hash.new(0)

    if cards.size != 5
      raise "Invalid hand!"
    end
  
    tcards = []
    cards.each do |card|
      c = Card.new(card)
      tcards.push(c)
      @pairs[c.value] += 1
    end
    @pairs.delete_if{|v,c| c <= 1}
    @cards = tcards.sort{|a, b|  b.value <=> a.value }

    setHandValue
  end

  def setPairs
    hp = @pairs.map{|x| x[1]}.sort.reverse
    return 0 if hp.size <= 0
    if hp.size == 1
      return 106 if hp[0]==4
      return 102 if hp[0]==3
      return 100
    end
    return 105 if hp[0]==3 #Have 3 of a kind and > 1 pairs so full house
    return 101 #two pairs and not full house
  end

  #Cards sorted reverse order
  def compareCards(otherHand)
    @cards.each_with_index do |c,i|
      debug "My card: #{c.showCard} theirs: #{otherHand.cards[i].showCard}"
      tie = c.compare(otherHand.cards[i])
      return tie if tie != 0
    end
    return 0 #Tie
  end

  def comparePairs(otherHand)
    otherPairs = otherHand.pairs.keys.sort.reverse #Set highest pair first
    winner = 0
    @pairs.keys.sort.reverse.each_with_index do |pair,idx|
      debug "My pair: #{pair} theirs: #{otherPairs[idx]}"
      next if pair==otherPairs[idx]
      return pair > otherPairs[idx] ? 1 : -1
    end

    return compareCards(otherHand)
  end

  #For straight, flush, royal, face value, highest card wins.
  #For others highest pair(s) win, then highest card
  def tieBreaker(otherHand)
    return compareCards(otherHand) if [0,108,107,104,103].include?(@value) #Highest card breads tie
    return comparePairs(otherHand) #Highest pair, then highest card
  end

  def setHandValue
    @value = setPairs
    @value = 103 if straight?
    @value = 104 if flush?
    @value = 107 if straight? && flush?
    @value = 108 if royalFlush?
    @hand = HAND_VALUES[@value]
  end
  
  def debug(str)
    puts str  if DEBUG
  end
end
