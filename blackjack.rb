=begin
Author: Ellyssin Gimhae
License: MIT

This class defines all of the rules for blackjack.

deal_hand        - deals two cards to player and dealer
player_hit       - adds card to player's hand
dealer_play_hand - adds cards to dealers hand until the dealer's total is > 17 
print_hands      - displays the hands of player and dealer
player_total     - returns the total of player
dealer_total     - returns the total of the dealer
=end

require "shoe.rb"
require "player.rb"

class BlkJk
    
  attr_reader :player
  attr_reader :dealer
  
  def initialize
    @player = Player.new
    @dealer = Player.new
    
    @shoe = Shoe.new(4)
    @shoe.shuffle_cards()
  end
  
  def deal_hand
    if(@shoe.size <=20)
      @shoe = Shoe.new(4)
      @shoe.shuffle_cards()
    end
    
    @dealer.clear_hands
    @player.clear_hands
    2.times do 
      #dealer
      @dealer.add_card_to_hand(@shoe.deal_card())
      #player
      @player.add_card_to_hand(@shoe.deal_card())
    end
    card = @shoe.deal_card()
  end
  
  def player_hit(hand_num=0)
    @player.add_card_to_hand(@shoe.deal_card(), hand_num)
  end
  
  def dealer_play_hand
    while @dealer.hand_total < 17
      @dealer.add_card_to_hand(@shoe.deal_card())
    end
  end
  
  def print_hands(all=false)
    puts "======================"
    if all      
      print "DEALER: "
      @dealer.card_hand.each { |c| print "#{c} "}
      puts ""
    else
      puts "DEALER: X #{@dealer.card_hand[1]}"
    end
    
    print "PLAYER: "
    @player.hands.times { |i|
      if(i > 0)
        print "        "
      end
      @player.card_hand(i).each { |c| print "#{c} "}
      print "\n"
    }
    puts "======================"
  end
  
  def player_total(hand_num=0)
    @player.hand_total(hand_num)
  end
  
  def dealer_total
    @dealer.hand_total
  end
end







