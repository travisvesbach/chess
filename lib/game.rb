require_relative "board.rb"
require_relative "ai.rb"
require "json"

class Game

	attr_accessor :current_turn, :player_one, :player_two, :board

	def initialize
		@current_turn = false
		@player_one = 'white'
		@player_two = 'black'
		@ai_on = false
		@ai_color = 'black'
		menu
	end

	#the main menu, from which the user can choose what to do
	def menu
		puts "------"
		puts "Chess!"
		puts "------"
		puts "Main Menu"
		puts ""
		puts "Enter one of the following:"
		puts "New"
		if @board
			puts "Resume"
			puts "Save"
		end
		puts "Load"
		puts "Quit"
		puts ""
		input = gets.chomp.downcase 
		case input
		when 'new'
			@board = Board.new
			clear_screen
			set_ai
			clear_screen
			game_engine
		when 'resume'
			clear_screen
			game_engine
		when 'save'
			to_json
			clear_screen
			puts ">Game saved<"
			menu
		when 'load'
			@board = Board.new
			from_json
#			clear_screen
			puts @board
#			puts @board.board
			puts ">Game loaded<"
			game_engine
		when 'quit'
			abort(">Exiting game<")
		else
			clear_screen
			error
			menu
		end
	end

	#outputs an error for invalid input
	def error
		puts "*********************"
		puts "<ERROR> Invalid input"
		puts "*********************"
	end

	#clears the screen
	def clear_screen
		system "clear" or system "cls"
	end

	#turns the AI on or off depending on the user input
	def set_ai
		puts "Enter [1] to play against the computer or [2] for 2 people!"
		input = gets.chomp.to_i
		if input == 1
			@ai_on = true
		elsif input == 2
			@ai_on = false
		else
			error
			set_ai			
		end
	end

	#loads a previously saved game's variables 
	def from_json
#		data = JSON.parse File.read("save.json")
#		@board = Board.new(data["board"], data["positions"]),
#		@current_turn = data["current_turn"]
#		@ai_on = data["ai_on"]
		@board = Board.new(true)
		@current_turn = @board.turn
	end	

	#saves the current game
	def to_json
		@board.to_json(@current_turn)
#		File.write("save.json", JSON.dump({
#			:board => @board.board,
#			:positions => @board.positions,
#			:current_turn => @current_turn,
#			:ai_on => @ai_on
#			}))
	end

	def game_engine
		if @ai_on == true
			game_with_ai
		else
			game_with_two_players
		end
		announce_winner
		end_of_game
	end

	def game_with_ai
		@current_turn = @player_one
		finish = false
		@ai = Ai.new
		until finish
			puts @current_turn
			@board.show
			return if check_or_checkmate(@current_turn) == "CHECKMATE"
			if @current_turn == @player_one
				move
				@current_turn = @ai_color
			elsif @current_turn == @ai_color
				@board = @ai.move(@board.board)
				@current_turn = @player_one
			end
		end
	end

	def game_with_two_players
		@current_turn = @player_one if @current_turn == false
		finish = false
		until finish
			puts @current_turn
			@board.show
			return if check_or_checkmate(@current_turn) == "CHECKMATE"
			finish = move
			if @current_turn == @player_one
				@current_turn = @player_two
			elsif @current_turn == @player_two
				@current_turn = @player_one
			end
		end
	end

	def move
		piece = false
		target = false
		until piece != false
			puts "Select a piece (ex: [b1]) or enter [menu] for the menu."
			input = gets.chomp.downcase
			case input
			when "menu"
				menu
			else
				piece = convert_input_into_location(input)
				piece = @board.valid_piece(piece, @current_turn) if piece != false
			end
			error if piece == false
		end
		until target != false
			puts "Select a destination or enter [back] for back or [menu] for the menu."
			input = gets.chomp.downcase
			case input
			when "menu"
				menu
			when "back"
				move
				return
			else
				target = convert_input_into_location(input)
				puts "Piece = #{piece}"
				puts "Target = #{target}"
				target = @board.check_target(piece, target) if target != false
				puts "Target = #{target}"
			end
			error if piece == false
		end
		if @board.move(piece, target, @current_turn) == false
			clear_screen
			error
			@board.show
			move
		end
		false
	end

	def convert_input_into_location(input)
		x = input[0]
		case x
		when 'a'
			x = 1
		when 'b'
			x = 2
		when 'c'
			x = 3
		when 'd'
			x = 4
		when 'e'
			x = 5
		when 'f'
			x = 6
		when 'g'
			x = 7
		when 'h'
			x = 8
		else
			return false
		end
		y = input[1]
		case y
		when '1'
			y = 8
		when '2'
			y = 7
		when '3'
			y = 6
		when '4'
			y = 5
		when '5'
			y = 4
		when '6'
			y = 3
		when '7'
			y = 2
		when '8'
			y = 1
		else
			return false
		end
		[x,y]
	end

	def check_or_checkmate(color)
		result = @board.check_or_checkmate(color)
		if result == 'CHECK' or result == 'CHECKMATE'
			puts "You are in #{result}!"
		end
		result
	end

	def announce_winner
		@board.show
		case @current_turn
		when @player_one
			if @ai == false
				puts "Player 2 is the winner!"
			elsif @ai == true
				puts "The computer is the winner!"
			end
		when @player_two
			puts "Player 1 is the winner!"
		when @ai_color
			puts "You are the winner!"
		end
	end

	def end_of_game
		puts ""
		puts "Would you like to play again? [Y]es or [N]o"
		input = gets.chomp.upcase
		if input == 'Y'
			clear_screen
			initialize
		elsif input == 'N'
			:exit
		else
			error
			end_of_game
		end
	end
end

game = Game.new