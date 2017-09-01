#require_relative "game.rb"
require "json"

class Board

	attr_accessor :board, :positions

	def initialize(json = false)
		if json == false
			@board = Hash.new
			@positions = []
			make_board
		else
			@turn = from_json
#			@board = board
#			@positions = positions
#			@board.each do |key, value|
#				puts "#{key} #{value}"
#			end
		end

	end

	def make_board
		(1..8).each do |x|
            (1..8).each do |y|
            	@positions << [x,y]
                @board[[x,y]] = Square.new
            end
        end
        @board[[1,1]] = Rook.new([1,1], 'black')
        @board[[2,1]] = Knight.new([2,1], 'black')
        @board[[3,1]] = Bishop.new([3,1], 'black')
        @board[[4,1]] = Queen.new([4,1], 'black')
        @board[[5,1]] = King.new([5,1], 'black')
        @board[[6,1]] = Bishop.new([6,1], 'black')
        @board[[7,1]] = Knight.new([7,1], 'black')
        @board[[8,1]] = Rook.new([8,1], 'black')
        @board[[1,2]] = Pawn.new([1,2], 'black')
        @board[[2,2]] = Pawn.new([2,2], 'black')
        @board[[3,2]] = Pawn.new([3,2], 'black')
        @board[[4,2]] = Pawn.new([4,2], 'black')
        @board[[5,2]] = Pawn.new([5,2], 'black')
        @board[[6,2]] = Pawn.new([6,2], 'black')
        @board[[7,2]] = Pawn.new([7,2], 'black')
        @board[[8,2]] = Pawn.new([8,2], 'black') 

        @board[[1,8]] = Rook.new([1,8], 'white')
        @board[[2,8]] = Knight.new([2,8], 'white')
        @board[[3,8]] = Bishop.new([3,8], 'white')
        @board[[4,8]] = Queen.new([4,8], 'white')
        @board[[5,8]] = King.new([5,8], 'white')
        @board[[6,8]] = Bishop.new([6,8], 'white')
        @board[[7,8]] = Knight.new([7,8], 'white')
        @board[[8,8]] = Rook.new([8,8], 'white')
        @board[[1,7]] = Pawn.new([1,7], 'white')
        @board[[2,7]] = Pawn.new([2,7], 'white')
        @board[[3,7]] = Pawn.new([3,7], 'white')
        @board[[4,7]] = Pawn.new([4,7], 'white')
        @board[[5,7]] = Pawn.new([5,7], 'white')
        @board[[6,7]] = Pawn.new([6,7], 'white')
        @board[[7,7]] = Pawn.new([7,7], 'white')
        @board[[8,7]] = Pawn.new([8,7], 'white') 

        get_all_moves
	end

	def valid_move(target, color, board, positions)
		if positions.include?(target)
			if board[target].symbol != " "
				target_oppose = board[target]
				if target_oppose.color == color
					return 'friendly'
				elsif target_oppose.color != color
					return 'capture'
				end
			else
				return 'free'
			end
		else
			return 'out'
		end
	end

	def valid_piece(piece, color)
		if @board[piece].class != Square and @board[piece].color == color
			return piece
		else
			return false
		end
	end

	def check_target(piece, target)
		if @board[piece].moves.include?(target)
			return target
		else
			return false
		end
	end

	def get_all_moves
		@board.each do |key, piece|
			piece.get_moves(key, @board, @positions) unless piece.class == Square
		end
	end

	def move(piece, target, color)
		target_holder = @board[target]
		current_holder = @board[piece]
		@board[target] = @board[piece]
		@board[piece] = Square.new
		@board[target].position = target
		check_for_pawn_at_end		
		get_all_moves
		result = king_in_check(color)
		puts "king_in_check result is #{result}"
		if king_in_check(color) == true
			puts "resetting positions"
			@board[piece] = current_holder
			@board[target] = target_holder
			get_all_moves
			return false
		end			
		true
	end

	def test_move(piece, target, color)
		target_holder = @board[target]
		current_holder = @board[piece]
		puts "testing #{@board[piece].symbol}"
		puts "moves are #{@board[piece].moves.to_s}"
		@board[target] = @board[piece]
		@board[piece] = Square.new
		check_for_pawn_at_end		
		get_all_moves
		result = king_in_check(color) #returns true or false
		@board[piece] = current_holder
		@board[target] = target_holder
		get_all_moves
		result
	end

	def king_in_check(color)
		king = false
		@board.each do |key, piece| 
			if piece.color == color and piece.class == King
				king = key
			end
		end
		@board.each do |key, piece|
			if piece.color != color and piece.moves.include?(@board[king].position)
				puts "in check from #{piece.symbol} at #{key.to_s}"
				puts "this pieces moves are #{piece.moves.to_s}"
				puts "and the king is at #{king.to_s}"
				return true	
			end
		end
		return false
	end

	def check_or_checkmate(color)
		puts "entering check_or_checkmate"
		if king_in_check(color)
			result = move_other_to_block(color)
			puts "result from move_other_to_block #{result}"
			return 'CHECK' if result == false
			result = move_king_to_stop_check(color)
			return result
		end
		false
	end

	def move_other_to_block(color)
		@board.each do |key, piece|
			if piece.color == color and piece.class != King
				piece.moves.each do |target| 
					result = test_move(key, target, color)
					print "testing #{target} result: #{result}"
					return false if result == false
				end
			end
		end
		return 'CHECK'
	end

	def move_king_to_stop_check(color)
		king = false
		@board.each do |key, piece|
			if piece.color == color and piece.class == King
				king = @board[key]
			end
		end
		king.moves.each do |target|
			puts "checking king move for check: #{target}"
			result = test_move(king.position, target, color) # returns true or false
			puts "result is #{result}"
			return 'CHECK' if result == false
		end
		return 'CHECKMATE'
	end


	def check_for_pawn_at_end
		ends = [[1,1],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1],[1,8],[2,8],[3,8],[4,8],[5,8],[6,8],[7,8],[8,8]]
		ends.each do |position|
			if @board[position].class == Pawn
				color = @board[position].color
				@board[position] = Queen.new(position, color)
			end
		end
	end


	def show
		puts "  ------------------------- "
		puts "8 |#{@board[[1,1]].symbol} |#{@board[[2,1]].symbol} |#{@board[[3,1]].symbol} |#{@board[[4,1]].symbol} |#{@board[[5,1]].symbol} |#{@board[[6,1]].symbol} |#{@board[[7,1]].symbol} |#{@board[[8,1]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "7 |#{@board[[1,2]].symbol} |#{@board[[2,2]].symbol} |#{@board[[3,2]].symbol} |#{@board[[4,2]].symbol} |#{@board[[5,2]].symbol} |#{@board[[6,2]].symbol} |#{@board[[7,2]].symbol} |#{@board[[8,2]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "6 |#{@board[[1,3]].symbol} |#{@board[[2,3]].symbol} |#{@board[[3,3]].symbol} |#{@board[[4,3]].symbol} |#{@board[[5,3]].symbol} |#{@board[[6,3]].symbol} |#{@board[[7,3]].symbol} |#{@board[[8,3]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "5 |#{@board[[1,4]].symbol} |#{@board[[2,4]].symbol} |#{@board[[3,4]].symbol} |#{@board[[4,4]].symbol} |#{@board[[5,4]].symbol} |#{@board[[6,4]].symbol} |#{@board[[7,4]].symbol} |#{@board[[8,4]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "4 |#{@board[[1,5]].symbol} |#{@board[[2,5]].symbol} |#{@board[[3,5]].symbol} |#{@board[[4,5]].symbol} |#{@board[[5,5]].symbol} |#{@board[[6,5]].symbol} |#{@board[[7,5]].symbol} |#{@board[[8,5]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "3 |#{@board[[1,6]].symbol} |#{@board[[2,6]].symbol} |#{@board[[3,6]].symbol} |#{@board[[4,6]].symbol} |#{@board[[5,6]].symbol} |#{@board[[6,6]].symbol} |#{@board[[7,6]].symbol} |#{@board[[8,6]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "2 |#{@board[[1,7]].symbol} |#{@board[[2,7]].symbol} |#{@board[[3,7]].symbol} |#{@board[[4,7]].symbol} |#{@board[[5,7]].symbol} |#{@board[[6,7]].symbol} |#{@board[[7,7]].symbol} |#{@board[[8,7]].symbol} |"
		puts "--|--+--+--+--+--+--+--+--|"
		puts "1 |#{@board[[1,8]].symbol} |#{@board[[2,8]].symbol} |#{@board[[3,8]].symbol} |#{@board[[4,8]].symbol} |#{@board[[5,8]].symbol} |#{@board[[6,8]].symbol} |#{@board[[7,8]].symbol} |#{@board[[8,8]].symbol} |"
		puts "  ------------------------- "
		puts "   a |b |c |d |e |f |g |h  "
	end

	#loads a previously saved game's variables 
	def from_json
		data = JSON.load File.read("save.json")
		@board = data["board"]
		@positions = data["positions"]
		current_turn = data["current_turn"]
		current_turn
	end	

	#saves the current game
	def to_json(current_turn)
		File.write("save.json", JSON.dump({
			:board => @board,
			:positions => @positions,
			:current_turn => current_turn,
			}))
	end

end

class Pawn < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265F"
		else
			@symbol = "\u2659"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		if @color == 'white'
			case valid_move([@position[0], @position[1] - 1], @color, board, positions)
			when 'free'
				@moves << [@position[0], @position[1] - 1]
				if @position[1] == 7
				case valid_move([@position[0], @position[1] - 2], @color, board, positions)
				when 'free'
					@moves << [@position[0], @position[1] - 2]
				end
			end
			end
			case valid_move([@position[0] + 1, @position[1] - 1], @color, board, positions)
			when 'capture'
				@moves << [@position[0] + 1, @position[1] - 1]
			end
			case valid_move([@position[0] - 1, @position[1] - 1], @color, board, positions)
			when 'capture'
				@moves << [@position[0] - 1, @position[1] - 1]
			end
		end
		if @color == 'black'
			case valid_move([@position[0], @position[1] + 1], @color, board, positions)
			when 'free'
				@moves << [@position[0], @position[1] + 1]
				if @position[1] == 2
					case valid_move([@position[0], @position[1] + 2], @color, board, positions)
					when 'free'
						@moves << [@position[0], @position[1] + 2]
					end
				end
			end
			case valid_move([@position[0] + 1, @position[1] + 1], @color, board, positions)
			when 'capture'
				@moves << [@position[0] + 1, @position[1] + 1]
			end
			case valid_move([@position[0] - 1, @position[1] + 1], @color, board, positions)
			when 'capture'
				@moves << [@position[0] - 1, @position[1] + 1]
			end
		end	
	end

end

class Rook < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265C"
		else
			@symbol = "\u2656"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y -= 1
		end	
	end

end

class Knight < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265E"
		else
			@symbol = "\u2658"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		move_path = [[2,1],[2,-1],[1,2],[1,-2],[-1,2],[-1,-2],[-2,1],[-2,-1]]
		move_path.each do |x,y|
			move_x = @position[0] + x
			move_y = @position[1] + y
			if move_x >= 1 and move_x <= 8 and move_y >= 1 and move_y <= 8
				case valid_move([move_x,move_y], @color, board, positions)
				when 'free'
					@moves << [move_x, move_y]
				when 'capture'
					@moves << [move_x, move_y]
				end
			end
		end
	end

end

class Bishop < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265D"
		else
			@symbol = "\u2657"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		x = @position[0] + 1
		y = @position[1] + 1
		continue = true
		until x > 8 or y > 8 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
			y += 1
		end
		x = @position[0] + 1
		y = @position[1] - 1	
		continue = true	
		until x > 8 or y < 1 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
			y -= 1
		end
		x = @position[0] - 1
		y = @position[1] + 1	
		continue = true	
		until x < 1 or y > 8 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y += 1
		end
		x = @position[0] - 1
		y = @position[1] - 1
		continue = true	
		until x < 1 or y < 1 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y -= 1
		end
	end

end

class Queen < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265B"
		else
			@symbol = "\u2655"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		#From Rook
		x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 or continue == false
			move = [x,y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y -= 1
		end
		#From Bishop
		x = @position[0] + 1
		y = @position[1] + 1
		continue = true
		until x > 8 or y > 8 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
			y += 1
		end
		x = @position[0] + 1
		y = @position[1] - 1	
		continue = true	
		until x > 8 or y < 1 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
			y -= 1
		end
		x = @position[0] - 1
		y = @position[1] + 1	
		continue = true	
		until x < 1 or y > 8 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y += 1
		end
		x = @position[0] - 1
		y = @position[1] - 1
		continue = true	
		until x < 1 or y < 1 or continue == false
			move = [x, y]
			case valid_move(move, @color, board, positions)
			when 'free'
				@moves << move
			when 'capture'
				@moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y -= 1
		end
	end
end

class King < Board

	attr_accessor :symbol, :color, :moves, :position

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265A"
		else
			@symbol = "\u2654"
		end
	end

	def get_moves(position, board, positions)
		@position = position
		@moves = Array.new
		move_path = [[-1,1],[0,1],[1,1],[0,-1],[0,1],[-1,-1],[-1,0],[1,-1]]
		move_path.each do |x,y|
			move_x = @position[0] + x
			move_y = @position[1] + y
			if move_x >= 1 and move_x <= 8 and move_y >= 1 and move_y <= 8
				case valid_move([move_x,move_y], @color, board, positions)
				when 'free'
					@moves << [move_x, move_y]
				when 'capture'
					@moves << [move_x, move_y]
				end
			end
		end
	end

end

class Square

	attr_accessor :symbol, :color, :moves

	def initialize
		@symbol = " "
		@color = " "
		@moves = []
	end

end


