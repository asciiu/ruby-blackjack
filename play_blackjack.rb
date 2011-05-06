=begin
Author: Ellyssin Gimhae
License: MIT
=end

require "blackjack.rb"
STDOUT.sync = true
blackjack = BlkJk.new

begin
  print "\nInput bankroll! "
  player_input = gets.chomp
end while player_input =~ /\D+/

bankroll = player_input.to_i
puts "Bankroll: " + player_input

while true
  
  while true
    print "Place your bet! "
    bet = gets.chomp
    if bet =~ /\D+/
      puts "Must be numeric"
    elsif bet.to_i > bankroll
      puts "Must be less than bankroll"
    elsif bet.to_i % 5 != 0 || bet.to_i < 5 
      puts "Bet min is 5"
    else
      break
    end
  end
  puts "Current bet: " + bet
  bet = bet.to_i
  
  blackjack.deal_hand
  
  insurance = 0
  dealer_cards = blackjack.dealer.card_hand
  if dealer_cards[1][0] == "A" && (bet/2)+bet <= bankroll
    blackjack.print_hands
    
    puts "Insurance? y/n "
    input = gets.chomp
    if input == 'y'
      # insurance will always be half the original bet for now
      insurance = bet/2
    end
    # dealer checks for black jack
    if blackjack.dealer_total == 21
      puts "Dealer has BJ!"
      blackjack.print_hands
      bankroll += insurance
      # TODO need to add check for player black jack here
      next
    else
      bankroll -= insurance
    end
  end
  
  
  player = blackjack.player
  # players turn
  play_hand = 0
  while true
    if(player.hand_total(play_hand) >= 21)
      # player cannot play the current hand
      # move on to the next hand
      play_hand +=1
      # check if there are any more hands to play
      if(play_hand >= player.hands)
        break
      end
    end
    
    blackjack.print_hands
    
    print "(h)it (s)tand"
    
    # NOTE: you'll also have to place a check here to determine
    # if the player has enough money to split
    if player.can_split?(play_hand) && bet * 2 <= bankroll
      print " sp(l)it"
    end 
    
    if bet * 2 <= bankroll && player.card_hand(play_hand).size == 2
      print " (d)ouble down"
    end
    
    print ": "
    
    player_input = gets.chomp
    if player_input == 'h'
      blackjack.player_hit(play_hand)
      #blackjack.print_hands
    elsif player_input == 's'
      play_hand += 1
      if(play_hand >= player.hands)
        break
      end
    elsif player_input == 'l'
      player.split_hand
    elsif player_input == 'd'
      bet *= 2
      blackjack.player_hit(play_hand)
      play_hand +=1
      break
    end
  end
  
  # dealers turn
  blackjack.dealer_play_hand
  
  # game is over show all
  blackjack.print_hands(true)
  
  # did player play more than 1 hand?
  play_hand.times {|i| 
    if(blackjack.player_total(i) <= 21 && 
      (blackjack.player_total(i) > blackjack.dealer_total || blackjack.dealer_total > 21))
      
      print "Player Wins! "
      
      if blackjack.player_total(i) == 21 and blackjack.player.card_hand(i).size == 2
        puts "Blackjack"
        bankroll += bet * 1.5
      else
        puts ""
        bankroll += bet
      end
    elsif blackjack.player_total(i) == blackjack.dealer_total
      
       if blackjack.player_total(i) == 21 &&  
         blackjack.player.card_hand.size == 2 && 
         blackjack.dealer.card_hand.size != 2
         puts "Player Blackjack!"
         bankroll += bet * 1.5
       else
         puts "Push"
       end
    else
      puts "Dealer Wins"
      bankroll -= bet
    end
  }
  
  puts "Bankroll: " + bankroll.to_s
  if(bankroll <= 0)
    puts "Game over dude!"
    break
  end
    
  print "\nPlay again? y/n "
  player_input = gets.chomp
  if player_input == 'n'
    break
  end
end