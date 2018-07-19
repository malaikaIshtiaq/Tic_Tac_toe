class TicTacToe
    attr_reader :gameboard, :current_player
    
    WINNING_LINES = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  
    def initialize
      @player1 = Player.new
      @player2 = Player.new
      @gameboard = Gameboard.new
      @current_player = @player1
    end
  
    def start_game
      puts "Welcome to TicTacToe!"
      gameboard.draw_board
      while 1
        puts "It's #{current_player.player_id}'s turn!"
        puts "Enter slot number, being 1 the top left corner and 9 bottom right"
        puts "Enter exit to leave the game"
        input = gets.chomp
        input = input_validation(input) 
        break if input == "exit"
        place_token(input) 
        gameboard.draw_board
        look_for_winner
        board_full?
        next_turn
      end
    end
  
    private
  
    def board_full?
      if gameboard.slots.all? {|slot| slot.class == Token }
        puts "It's a draw!"
        gameboard.reset_board
      end
    end
  
    def look_for_winner 
      winner = WINNING_LINES.any? do |line|
                 line.all? do |index|
                 if gameboard.slots[index].class == Token 
                   gameboard.slots[index].token_owner == current_player.player_id
                 end
               end
             end
      if winner
        print_winner(current_player.player_id)
      end           
    end
  
    def print_winner(winner)
      puts "#{winner} won!"
      gameboard.reset_board
    end
  
    def next_turn
      @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end
  
    def place_token(location)
      gameboard.slots[location] = Token.new(current_player.player_id)
    end
    
    def input_validation(input)
      return "exit" if input.downcase == "exit"
      input = input.to_i
      while 1
        while !(input.between?(1,9))
          puts "Please, enter a number between 1 and 9"
          input = gets.chomp.to_i
        end
        if gameboard.slots[input - 1].class == Token
          puts "Slot not empty, please enter a different one"
          input = gets.chomp.to_i
          next 
        end
        return input - 1
      end
    end
    
    class Player
      attr_accessor :player_id
  
        @@player_count = 0
        
        def initialize
        @@player_count += 1
        @player_id = "player#{@@player_count}"
        end    
    end
  
    class Gameboards
      attr_accessor :slots
        
        def initialize
          @slots = (1..9).to_a
        @slots.map! { |slot| slot = "empty slot" }
        end
      
      def draw_board
        slots.each_with_index do |slot, index|
          if index == 2 || index == 5 || index == 8   
            if slot.class == Token
              puts "| #{slot.token_model} |"
            else
              puts "|   |"
            end
          else
            if slot.class == Token
              print "| #{slot.token_model} |"
            else
              print "|   |"
            end
          end
        end
      end
  
      def reset_board
        @slots.map! { |slot| slot = "empty slot" }
      end  
    end
  
    class Token
      attr_reader :token_model, :token_owner
      def initialize(player_id)
        @token_owner = player_id
        @token_owner == "player1" ? @token_model = "X" : @token_model = "O"
      end 
    end
  
  end
  
  my_game = TicTacToe.new
  my_game.start_game