require "test/unit"
require './hand'
require './card'

class HandTest < Test::Unit::TestCase
  PAIR01 = Hand.new(['2c', '2d', '5S', '4S', '6S'])
  PAIR02 = Hand.new(['3c', '3d', '5c', '4S', '6S'])

  TPAIR = Hand.new(['2c', '2d', '5S', '5h', '6d'])

  TKIND = Hand.new(['2c', '2d', '2H', '5S', '6S'])
  STRAIGHT = Hand.new(['2C', '3S', '4D', '5H', '6C'])
  FLUSH = Hand.new(['KS', '2S', 'QS', '5S', 'TS'])
  FULL = Hand.new(['2C', '2d', '2h', '6H', '6S'])
  FKIND = Hand.new(['2c', '2d', '2h', '2S', '6S'])
  SFLUSH = Hand.new(['2S', '3S', '4S', '5S', '6S'])
  RFLUSH = Hand.new(['KS', 'AS', 'QS', 'JS', 'TS'])

  def test_hands
    assert_true RFLUSH.royalFlush?

    assert_true SFLUSH.flush?
    assert_true SFLUSH.straight?
    assert_false SFLUSH.royalFlush?
    
    assert_true FLUSH.flush?
    assert_false FLUSH.straight?

    assert_true STRAIGHT.straight?
    assert_false STRAIGHT.flush?

    assert_true FKIND.value == 106
    assert_true FULL.value == 105
    assert_true TKIND.value == 102
    assert_true TPAIR.value == 101
    assert_true PAIR01.value == 100
  end
  
  def test_compare
    assert_true RFLUSH.compare(SFLUSH)==1
    assert_true SFLUSH.compare(FKIND)==1
    assert_true FKIND.compare(FULL)==1
    assert_true FULL.compare(FLUSH)==1
    assert_true FLUSH.compare(STRAIGHT)==1
    assert_true STRAIGHT.compare(TKIND)==1

    assert_true TKIND.compare(TPAIR)==1
    assert_true TPAIR.compare(PAIR01)==1

    #Higest pair wins
    assert_true PAIR02.compare(PAIR01)==1

    #Highest pairs wind
    assert_true Hand.new(['3c', '3d', '3H', '5S', '6S']).compare(TKIND)==1
    assert_true Hand.new(['3c', '3d', '3h', '3S', '6S']).compare(FKIND)==1
    assert_true Hand.new(['2C', '2d', '2h', '7H', '7S']).compare(FULL)==1
    assert_true Hand.new(['3C', '3d', '3h', '6H', '6S']).compare(FULL)==1

    #Same pairs, high card wins
    assert_true Hand.new(['2c', '2d', '5S', '5h', '7d']).compare(TPAIR)==1
    assert_true Hand.new(['2c', '2d', '2H', '5S', '7S']).compare(TKIND)==1
    assert_true Hand.new(['2c', '2d', '2h', '2S', '8S']).compare(FKIND)==1

    assert_true Hand.new(['3S', '4D', '5H', '6C', '7H']).compare(STRAIGHT)==1
    assert_true Hand.new(['KS', 'QS', 'QS', '5S', 'TS']).compare(FLUSH)==1
    assert_true Hand.new(['3S', '4S', '5S', '6S', '7S']).compare(SFLUSH)==1
  end

end

class CardTest < Test::Unit::TestCase
  def test_suits
    'A'.upto('Z').to_a.each do |letter|
      next if Card::SUIT_VALUES.include?(letter)
      
      tcard = "3#{letter}"
      assert_raise do
        Card.new(tcard)
      end
    end

  end

  def test_card_values
    Card::SUIT_VALUES.each do |s|
      'A'.upto('Z').to_a.each do |letter|
        next if Card::CARD_VALUES.keys.include?(letter)
        tcard = "#{letter}#{s}"
        assert_raise do
          Card.new(tcard)
        end
      end

      [0,1] + 10.upto(99).to_a.each do |val|
        tcard = "#{val}#{s}"
        assert_raise do
          Card.new(tcard)
        end
      end

    end
  end

  def test_valid_cards
    Card::SUIT_VALUES.each do |s|
      Card::CARD_VALUES.keys + 2.upto(9).to_a.each do |fc|
        tcard = "#{fc}#{s}"
        assert_equal tcard, Card.new(tcard).card
      end
    end
  end

end