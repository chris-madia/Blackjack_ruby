require_relative "deck"
require_relative "card"


    class Player
      attr_accessor :score, :funds, :bet, :hand

      def initialize
        @hand = [];
        @score = 0;
        @bet = 0;
        @funds = 100;
      end

      def reset
        @hand = [];
        @score = 0;
        @bet = 0;
      end

      def hand(cards)
        @hand += cards
        calculate_score
      end

      def place_bet
        amount = 0
        while true
          begin
            amount = Integer(gets)
            if amount <= @funds && amount > 0
              @bet += amount
              @funds -= amount
              break
            elsif amount > @funds
              puts "Sadly, you don't have enough funds to place this bet. Please enter a lower bet."
            else
              puts "You cannot place a zero or negative bet."
            end
          rescue
            puts "Please enter a valid whole amount."
          end
        end
      end

      def update_funds(amount)
        @funds += amount
      end

      def calculate_score
        @score = 0
        ace_in_hand = false

        @hand.each do |h|
         face_value = h.get_value[1]
         if face_value.is_a? Integer
           @score += face_value
         elsif face_value != :Ace
           @score += FACEVALUE
         else
           @score += 1
           ace_in_hand = true
         end
        end

        if ace_in_hand
          if @score + FACEVALUE <= BLACKJACK then @score += FACEVALUE end
        end
      end

      def print_hand
        hand_as_string = ""
        @hand.each do |card|
          card_value = card.get_value
          hand_as_string += "#{card_value[0]}, #{card_value[1]} | "
        end
        return hand_as_string
      end
    end

    def determine_winner(player, dealer)

      amount = 0

      if dealer.score > BLACKJACK && player.score > BLACKJACK
        puts "\n**No one wins!**\n"
      elsif player.score < dealer.score && dealer.score <= BLACKJACK ||
        player.score > BLACKJACK
        puts "\n***Dealer wins***\n"
      elsif dealer.score < player.score && player.score <= BLACKJACK ||
        dealer.score > BLACKJACK
        puts "\n****Player wins!****\n"
        if player.score == BLACKJACK && player.hand.size == 2
          amount = player.bet + player.bet * 1.5
        else
          amount = player.bet * 2
        end
      else
        puts "\nIt's a draw!\n"
        amount = player.bet
      end

      player.update_funds(amount)

    end

    BLACKJACK = 21;
    FACEVALUE = 10;
    DEALER_STANDS_AT = 16;

    puts "Welcome to blackjack!"
    puts "You currently have $100 in funds."

    keep_playing = true
    player = Player.new
    dealer = Player.new
    while keep_playing
      deck = Deck.new
      player.reset
      dealer.reset
      puts "How much would you like to bet?"
      player.place_bet
      player.hand(deck.draw(2))
      dealer.hand(deck.draw)
      puts "\nYour current hand is: #{player.print_hand} \nYour score is: #{player.score}\n."
      puts "The dealer's hand is: #{dealer.print_hand}\nThe dealers score is: #{dealer.score}\n"
      dealer.hand(deck.draw)
      if dealer.score != BLACKJACK
        until player.score > BLACKJACK do
          puts "\nDo you want to hit (h) or stand (s)?"
          players_move = String(gets)

          case players_move[0].downcase
          when "s"
            # stand
            break
          when "h"
            # hit
            puts "\nYou decided to hit!\n"
            player.hand(deck.draw)
            puts "\nYour hand is #{player.print_hand}\nYour score is: #{player.score}."
          else
            puts "Unknow input. Please try again.\n"
          end
        end
        puts "\nYour move has ended, resolving the dealers hand.\n"
        while dealer.score <= DEALER_STANDS_AT
          dealer.hand(deck.draw)
        end
        puts "\nThe dealer's hand is #{dealer.print_hand} \nThe dealers score is: #{dealer.score}"
      end
      determine_winner(player, dealer)
      puts "At the end of the game your funds stand at $#{player.funds}."
      while true
        puts "Do you want to play again? (Y/N)"
        play_again = String(gets)
        case play_again[0].downcase
        when "y"
          break
        when "n"
          keep_playing = false
          break
        end
      end
    end
