#!/usr/bin/ruby

require './hand'

POKER_FILE = File.join(".", "poker.txt")

#Put in round class?
STATS = {
  hands: 0,
  errors:  0,
  player1: {
    wins: 0,
    ties: 0,
    loss: 0,
    high: nil
  },
  player2: {
    wins: 0,
    ties: 0,
    loss: 0,
    high: nil
  }
}

if !File.exists?(POKER_FILE)
  raise "File #{POKER_FILE} does not exist"
end

File.open(POKER_FILE, "rb").each_with_index do |line, index|
  line.chomp!
  hands = line.split() #whitespace file
  leftHand = Hand.new( hands[0..4] )
  rightHand = Hand.new( hands[5..-1] )

  STATS[:player1][:high] = leftHand if STATS[:player1][:high].nil? || leftHand.value > STATS[:player1][:high].value
  STATS[:player2][:high] = rightHand if STATS[:player2][:high].nil? || rightHand.value > STATS[:player2][:high].value
  
  winner = leftHand.compare(rightHand)
  if winner == 0
    p1 = "(Tie)"
    p2 = "(Tie)"
    STATS[:player1][:ties] += 1
    STATS[:player2][:ties] += 1
  elsif winner == 1
    STATS[:player1][:wins] += 1
    STATS[:player2][:loss] += 1
    p1 = "(Win)"
    p2 = "(Lose)"
  else
    STATS[:player2][:wins] += 1
    STATS[:player1][:loss] += 1
    p2 = "(Win)"
    p1 = "(Lose)"
  end
  printf("Player1 %7s : %s            Player2 %7s: %s\n", p1, leftHand.showHand, p2, rightHand.showHand) unless ARGV[0] =~ /s$/i

  STATS[:hands] = index+1
end

STATS[:player1][:high] = STATS[:player1][:high].hand
STATS[:player2][:high] = STATS[:player2][:high].hand  

puts ""
puts "-"*120
printf("%15s %10s %10s %10s %20s\n", "", "Wins", "Losses", "Ties", "Best Hand")
printf("%15s %10s %10s %10s %20s\n", "Player1", STATS[:player1][:wins], STATS[:player1][:loss], STATS[:player1][:ties], STATS[:player1][:high])
printf("%15s %10s %10s %10s %20s\n", "Player2", STATS[:player2][:wins], STATS[:player2][:loss], STATS[:player2][:ties], STATS[:player2][:high])

puts ""
puts "Rounds Played: #{STATS[:hands]}"
