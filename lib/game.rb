require_relative "board.rb"
require_relative "ai.rb"
require "json"
require "yaml"

class Game

	attr_accessor :current_turn, :player_one, :player_two, :board

	def initialize
		@current_turn = false
		@player_one = 'white'
		@player_two = false
		@ai_on = false
		@ai_color = 'black'
		menu
	end

	#the main menu, from which the user can choose what to do
	def menu
		clear_screen
		puts "------"
		puts "Chess!"
		puts "------"
		puts "Main Menu"
		puts ""
		puts "Enter one of the following:"
		puts "New"
		if @current_turn != false
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
			to_yaml
			clear_screen
			puts ">Game saved<"
			menu
		when 'load'
			@board = Board.new
			from_yaml
			clear_screen
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

	#Saves the current game state
	def to_yaml
		File.write("save.yaml", YAML.dump({
			:board => @board.board,
			:positions => @board.positions,
			:current_turn => @current_turn,
			:ai_on => @ai_on
			}))
	end

	#Loads a previously saved game
	def from_yaml
		data = YAML.load File.read("save.yaml")
		@board = Board.new(data[:board], data[:positions])
		@current_turn = data[:current_turn]
		@ai_on = data[:ai_on]		
	end

	#Main engine that runs the game
	def game_engine
		if @ai_on == true
			game_with_ai
		else
			@player_two = 'black'
			game_with_two_players
		end
		announce_winner
		end_of_game
	end

	#Takes turns between the player and AI until checkmate
	def game_with_ai
		@current_turn = @player_one if @current_turn == false
		@ai = Ai.new
		until check_or_checkmate(@current_turn) == "CHECKMATE"
			if @current_turn == @player_one
				move
				@current_turn = @ai_color
			elsif @current_turn == @ai_color
				@board = @ai.move(@board.board)
				@current_turn = @player_one
			end
			clear_screen
		end
	end

	#Takes turns between two players until checkmate
	def game_with_two_players
		@current_turn = @player_one if @current_turn == false
		until check_or_checkmate(@current_turn) == "CHECKMATE"
			move
			if @current_turn == @player_one
				@current_turn = @player_two
			elsif @current_turn == @player_two
				@current_turn = @player_one
			end
			clear_screen
		end
	end

	#Move function for interacting with the user(s)
	def move
		piece = false
		target = false
		until piece != false
			@board.show
			puts ""
			puts "#{@current_turn.capitalize}: Select a piece (ex: [b1]) or enter [menu]."
			piece_input = gets.chomp.downcase
			case piece_input
			when "menu"
				menu
			else
				piece = convert_input_into_location(piece_input)if piece_input.length == 2
				piece = @board.valid_piece(piece, @current_turn) if piece != false
			end
			if piece == false
				clear_screen
				error
			end
		end
		until target != false
			puts "Select a destination, or enter [back] or [menu]."
			input = gets.chomp.downcase
			case input
			when "menu"
				menu
			when "back"
				move
				return
			else
				target = convert_input_into_location(input)if input.length == 2
				target = @board.check_target(piece, target) if target != false
			end
			if target == false
				clear_screen
				error
				@board.show
				puts "Currently selected piece: #{piece_input}"
			end
		end
		if @board.move(piece, target, @current_turn) == false
			clear_screen
			error
			check_or_checkmate(@current_turn)
			move
		end
		false
	end

	#Converts the user input into the format used by the Board class.
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

	#Calls the check/chackmate functions from the board class outputs the result
	def check_or_checkmate(color)
		result = @board.check_or_checkmate(color)
		if result == 'CHECK' or result == 'CHECKMATE'
			puts ""
			puts "#{result}!"
			puts ""
		end
		result
	end

	#Outputs the winner of the game
	def announce_winner
		@board.show
		puts ""
		puts "**********************************"
		case @current_turn
		when @player_one
			if @ai == false
				puts "Checkmate! Player 2 is the winner!"
			elsif @ai == true
				puts "Checkmate! The computer is the winner!"
			end
		when @player_two
			puts "Checkmate! Player 1 is the winner!"
		when @ai_color
			puts "Checkmate! You are the winner!"
		end
	end

	#Asks if the user(s) would like to play a new game.
	def end_of_game
		puts ""
		puts "Would you like to play again? [Y]es or [N]o"
		input = gets.chomp.upcase
		if input == 'Y'
			clear_screen
			initialize
		elsif input == 'N'
			abort(">Exiting game<")
		else
			error
			end_of_game
		end
	end
end

game = Game.new