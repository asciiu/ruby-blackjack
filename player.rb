=begin
Author: Ellyssin Gimhae
License: MIT


A Player plays a hand in blackjack. As such the cards are in possession of the player.
The player can:

add_card_to_hand    - add a card to a hand 
clear_hands         - removes all cards from all hands that are being played
card_hand           - returns the set of cards in a given hand
hands               - returns the number of hands in play
can_split?          - returns true iff a hand can be split
split_hand          - splits a hand into two hands
print_hand          - prints a players hand
hand_total          - returns the total of a hand
=end
class Player 
  attr_reader :cards
  
  def initialize
    # keeps track of all card hands
    # a card hand is a set of cards 
    @card_hands = Array.new
    
    # keeps track of which card hand in @card_hands 
    # is the active hand
    @active_hand = 0
  end
  
  # adds a card to the player's hand defined by hand_num
  def add_card_to_hand(card,hand_num=0)
    if hand_num > @card_hands.size() && @card_hands.size() != 0
      return
    end
    
    unless @card_hands[hand_num]
      @card_hands[hand_num] = Array.new
    end
        
    @card_hands[hand_num] << card
  end
  
  def clear_hands
    @card_hands.clear
  end
  
  # returns the cards in a hand as an array
  def card_hand(hand_num=0)
    # the hand number cannot be greater than the number of hands
    if hand_num >= @card_hands.size
      return
    end
    
    @card_hands[hand_num]
  end
  
  # return the number of hands
  def hands
    return @card_hands.size
  end
  
  def can_split?(hand_num=0)
    # the hand number cannot be greater than the number of hands
    if hand_num >= @card_hands.size
      return false
    end
    
    hand = @card_hands[hand_num]
    
    # cannot split a hand that has more or less than 2 cards
    if hand.size > 2 || hand.size < 2
      return false
    end
    
    # if the first and second cards are 10 value cards then split is allowed
    if hand[0][0] =~ /[KQJT]/ && hand[1][0] =~ /[KQJT]/
      return true
    elsif hand[0][0] != hand[1][0]
      # cannot split a hand that does not contain same value cards
      return false
    end
    
    return true
  end
  
  # user is only allowed to split the first cards in a hand
  def split_hand(hand_num=0)
    # the hand number cannot be greater than the number of hands
    if hand_num >= @card_hands.size
      return
    end
    
    hand = @card_hands[hand_num]
    
    # cannot split a hand that does not contain same value cards
    unless can_split?(hand_num)
      return
    end
    
    # pop the last card in the hand
    card = hand.pop()
    
    new_hand = Array.new
    new_hand << card
    
    # insert the new hand after this hand but before 
    # the next hand
    @card_hands.insert(hand_num+1,new_hand)
  end
  
  def print_hand(hand_num=0)
    # the hand number cannot be greater than the number of hands
    if hand_num >= @card_hands.size
      return
    end
    
    card_hand = @card_hands[hand_num]
    
    card_hand.each {|c| print "#{c} "}
    print "\n"
  end
  
  # this will return the total value of a given hand
  def hand_total(hand_num=0)
    # the hand number cannot be greater than the number of hands
    if hand_num >= @card_hands.size
      return
    end
      
    cards = @card_hands[hand_num]
    
    total = 0
    cards.each { |c| 
      if /[23456789]/ =~ c
        total += c.to_i
      elsif /[KQJT]/ =~ c
        total += 10
      end
    }
    
    cards.each { |c|
      if /A./ =~ c
        total += 11
        # there were more than one ace in the hand 
        # therefore both aces are now evaled as 1
        if (total > 31)
          total -= 20
        elsif (total > 21)
          total -= 10
        end
      end      
    }
    total
  end
end
