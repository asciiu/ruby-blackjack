=begin
Author: Ellyssin Gimhae
License: MIT


Defines the blackjack shoe.

shuffle_cards   - shuffles the cards in the shoe
deal_card       - deals a card from the shoe
size            - returns the number of cards remaining in the shoe

=end

class Shoe
  CARDS = %w{A K Q J T 9 8 7 6 5 4 3 2}
  SUIT = %w{c d h s}

  def initialize(deck_num)
    @shoe = []
    deck_num.times do
      SUIT.each do |s|
        CARDS.each do |c|
          @shoe << "#{c.to_s}#{s.to_s}"
        end
      end
    end
  end
  
  def shuffle_cards
    @shoe.size.times do |i|
      j = rand(@shoe.size)
      @shoe[i],@shoe[j] = @shoe[j],@shoe[i]
    end
  end
  
  def deal_card
    @shoe.pop()
  end
  
  def size
    @shoe.size()
  end
end