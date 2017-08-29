#require 'game.rb'

class Board

	def initialize
		@board = Hash.new
		make_board
		@positions = []
		(1..8).each { |y| (1..8).each { |x| @positions << [x,y] }}
	end

	def make_board
		(1..8).each do |x|
            (1..8).each do |y|
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
	end

	def valid_move(target, color)
#		if @board.include?(target)
#			target_oppose = @board.index(target)
#			if target_oppose.color == color
#				return 'friendly'
#			elsif target_oppose.color != color
#				return 'capture'
#			end
#		else
#			return 'free'
#		end
		if @postions.include?(target)
			if @board[target] != "\u2610"
				target_oppose = @board[target]
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

	def show_board
		puts " ----------------------- "
		puts "|#{@board[[1,1]].symbol} |#{@board[[2,1]].symbol} |#{@board[[3,1]].symbol} |#{@board[[4,1]].symbol} |#{@board[[5,1]].symbol} |#{@board[[6,1]].symbol} |#{@board[[7,1]].symbol} |#{@board[[8,1]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,2]].symbol} |#{@board[[2,2]].symbol} |#{@board[[3,2]].symbol} |#{@board[[4,2]].symbol} |#{@board[[5,2]].symbol} |#{@board[[6,2]].symbol} |#{@board[[7,2]].symbol} |#{@board[[8,2]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,3]].symbol} |#{@board[[2,3]].symbol} |#{@board[[3,3]].symbol} |#{@board[[4,3]].symbol} |#{@board[[5,3]].symbol} |#{@board[[6,3]].symbol} |#{@board[[7,3]].symbol} |#{@board[[8,3]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,4]].symbol} |#{@board[[2,4]].symbol} |#{@board[[3,4]].symbol} |#{@board[[4,4]].symbol} |#{@board[[5,4]].symbol} |#{@board[[6,4]].symbol} |#{@board[[7,4]].symbol} |#{@board[[8,4]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,5]].symbol} |#{@board[[2,5]].symbol} |#{@board[[3,5]].symbol} |#{@board[[4,5]].symbol} |#{@board[[5,5]].symbol} |#{@board[[6,5]].symbol} |#{@board[[7,5]].symbol} |#{@board[[8,5]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,6]].symbol} |#{@board[[2,6]].symbol} |#{@board[[3,6]].symbol} |#{@board[[4,6]].symbol} |#{@board[[5,6]].symbol} |#{@board[[6,6]].symbol} |#{@board[[7,6]].symbol} |#{@board[[8,6]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,7]].symbol} |#{@board[[2,7]].symbol} |#{@board[[3,7]].symbol} |#{@board[[4,7]].symbol} |#{@board[[5,7]].symbol} |#{@board[[6,7]].symbol} |#{@board[[7,7]].symbol} |#{@board[[8,7]].symbol} |"
		puts "|--+--+--+--+--+--+--+--|"
		puts "|#{@board[[1,8]].symbol} |#{@board[[2,8]].symbol} |#{@board[[3,8]].symbol} |#{@board[[4,8]].symbol} |#{@board[[5,8]].symbol} |#{@board[[6,8]].symbol} |#{@board[[7,8]].symbol} |#{@board[[8,8]].symbol} |"
		puts " ----------------------- "
	end

end

class Pawn < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position
		@color = color
		if @color == 'white'
			@symbol = "\u265F"
		else
			@symbol = "\u2659"
		end
	end

	def get_moves
		moves = []
		if @color == 'white'
			case valid_move([@position[0], @position[1] + 1], @color)
			when 'free'
				moves << [@position[0], @position[1] + 1]
			end
			case valid_move([@position[0] + 1, @position[1] + 1], @color)
			when 'capture'
				moves << [@position[0] + 1, @position[1] + 1]
			end
			case valid_move([@position[0] - 1, @position[1] + 1], @color)
			when 'capture'
				moves << [@position[0] - 1, @position[1] + 1]
			end
			if @position[1] == 7
				case valid_move([@position[0], @position[1] + 2], @color)
				when 'free'
					moves << [@position[0], @position[1] + 2]
				end
			end
		end
		if @color == 'black'
			case valid_move([@position[0], @position[1] - 1], @color)
			when 'free'
				moves << [@position[0], @position[1] - 1]
			end
			case valid_move([@position[0] + 1, @position[1] - 1], @color)
			when 'capture'
				moves << [@position[0] + 1, @position[1] - 1]
			end
			case valid_move([@position[0] - 1, @position[1] - 1], @color)
			when 'capture'
				moves << [@position[0] - 1, @position[1] - 1]
			end
			if @position[1] == 7
				case valid_move([@position[0], @position[1] - 2], @color)
				when 'free'
					moves << [@position[0], @position[1] - 2]
				end
			end
		end
		moves		
	end

end

class Rook < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position = position
		@color = color
		if @color == 'white'
			@symbol = "\u265C"
		else
			@symbol = "\u2656"
		end
	end

	def get_moves
		moves = []
		x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y -= 1
		end
		moves		
	end

end

class Knight < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position
		@color = color
		if @color == 'white'
			@symbol = "\u265E"
		else
			@symbol = "\u2658"
		end
	end

	def get_moves
		moves = []
		move_path = [[2,1],[2,-1],[1,2],[1,-2],[-1,2],[-1,-2],[-2,1],[-2,-1]]
		move_path.each do |x,y|
			move_x = @position[0] + x
			move_y = @position[1] + y
			if move_x >= 1 and move_x <= 8 and move_y >= 1 and move_y <= 8
				case valid_move([move_x,move_y], @color)
				when 'free'
					moves << [move_x, move_y]
				when 'capture'
					moves << [move_x, move_y]
				end
			end
		end
		moves
	end

end

class Bishop < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position
		@color = color
		if @color == 'white'
			@symbol = "\u265D"
		else
			@symbol = "\u2657"
		end
	end

	def get_moves
		moves = []
		x = @position[0] + 1
		y = @position[1] + 1
		continue = true
		until x > 8 or y > 8 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x > 8 or y < 1 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x < 1 or y > 8 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x < 1 or y < 1 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y -= 1
		end
		moves
	end

end

class Queen < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position
		@color = color
		if @color == 'white'
			@symbol = "\u265B"
		else
			@symbol = "\u2655"
		end
	end

	def get_moves
		moves = []
		#From Rook
				x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 and continue == false
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x > 8 or y > 8 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x > 8 or y < 1 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x < 1 or y > 8 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
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
		until x < 1 or y < 1 and continue == false
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly', 'out'
				continue = false
			end
			x -= 1
			y -= 1
		end
		moves
	end
end

class King < Board

	attr_accessor :symbol

	def initialize(position, color)
		@position
		@color = color
		if @color == 'white'
			@symbol = "\u265A"
		else
			@symbol = "\u2654"
		end
	end

	def get_moves
		moves = []
		move_path = [[-1,1],[0,1],[1,1],[0,-1],[0,1],[-1,-1],[-1,0],[1,-1]]
		move_path.each do |x,y|
			move_x = @position[0] + x
			move_y = @position[1] + y
			if move_x >= 1 and move_x <= 8 and move_y >= 1 and move_y <= 8
				case valid_move([move_x,move_y], @color)
				when 'free'
					moves << [move_x, move_y]
				when 'capture'
					moves << [move_x, move_y]
				end
			end
		end

	end

end

class Square

	attr_accessor :symbol

	def initialize
		@symbol = " "
	end

end



game = Board.new

game.show_board