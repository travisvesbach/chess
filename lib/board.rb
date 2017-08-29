require 'game.rb'

class Board

	def initialize
		@board = make_board
	end

	def make_board
		board = []

	end

	def valid_move(target, color)
		if @board.include?(target)
			target_oppose = @board.index(target)
			if target_oppose.color == color
				return 'friendly'
			elsif target_oppose.color != color
				return 'capture'
			end
		else
			return 'free'
		end
	end

end

class Pawn < Board

	def initialize(position, color)
		@position
		@color = color
	end

	def get_moves
		moves = []
		if @position[1] == 2 and @color == "white"
			moves << [@position[0], @position[1] + 1]
			moves <<  [@position[0], @position[1] + 2]
		elsif @position[1] != 2 and @color == "white"
			moves << [@position[0], @position[1] + 1]
		elsif @position[1] == 7 and @color == "black"
			moves << [@position[0], @position[1] - 1]
			moves << [@position[0], @position[1] - 2]
		elsif @position[1] != 7 and @color == "black"
			moves << [@position[0], @position[1] - 1]
		end
		moves		
	end

end

class Rook < Board

	def initialize(position, color)
		@position = position
		@color = color
	end

	def get_moves
		moves = []
		x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 and continue
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			y -= 1
		end
		moves		
	end

end

class Knight < Board

	def initialize(position, color)
		@position
		@color = color
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
				when 'friendly'
				end
			end
		end
		moves
	end

end

class Bishop < Board

	def initialize(position, color)
		@position
		@color = color
	end

	def get_moves
		moves = []
		x = @position[0] + 1
		y = @position[1] + 1
		continue = true
		until x > 8 or y > 8 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
			y += 1
		end
		x = @position[0] + 1
		y = @position[1] - 1	
		continue = true	
		until x > 8 or y < 0 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
			y -= 1
		end
		x = @position[0] - 1
		y = @position[1] + 1	
		continue = true	
		until x < 0 or y > 8 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1
			y += 1
		end
		x = @position[0] - 1
		y = @position[1] - 1
		continue = true	
		until x < 0 or y < 0 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1
			y -= 1
		end
		moves
	end

end

class Queen < Board

	def initialize(position, color)
		@position
		@color = color
	end

	def get_moves
		moves = []
		#From Rook
				x = @position[0] + 1
		y = @position[1]
		continue = true
		until x > 8 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
		end
		x = @position[0] - 1
		continue = true
		until x < 1 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1			
		end
		x = @position[0]
		y = @position[1] + 1
		continue = true
		until y > 8 and continue
			move = [x,y]
			valid = valid_move(move, @color)
			case valid
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			y += 1 
		end
		y = @position[1] - 1
		continue = true
		until y < 1 and continue
			move = [x,y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			y -= 1
		end
		#From Bishop
		x = @position[0] + 1
		y = @position[1] + 1
		continue = true
		until x > 8 or y > 8 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
			y += 1
		end
		x = @position[0] + 1
		y = @position[1] - 1	
		continue = true	
		until x > 8 or y < 0 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x += 1
			y -= 1
		end
		x = @position[0] - 1
		y = @position[1] + 1	
		continue = true	
		until x < 0 or y > 8 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1
			y += 1
		end
		x = @position[0] - 1
		y = @position[1] - 1
		continue = true	
		until x < 0 or y < 0 and continue
			move = [x, y]
			case valid_move(move, @color)
			when 'free'
				moves << move
			when 'capture'
				moves << move
				continue = false
			when 'friendly'
				continue = false
			end
			x -= 1
			y -= 1
		end
		moves
	end
end

class King < Board

	def initialize(position, color)
		@position
		@color = color
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
				when 'friendly'
				end
			end
		end

	end

end