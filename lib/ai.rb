require_relative "board.rb"

class Ai 

	def initialize
		@board = Board.new
	end

	#The AI searches for a random piece and a random move and sends it to the board. If it fails, it tries again.
	def move(board)
		good = false
		until good == true
			@board.board = board		
			ai_pieces = Array.new
			@board.board.each do |key, piece|
				if piece.color == 'black'
					ai_pieces << key
				end
			end
			ai_pieces.each do |piece|
			end
			piece_to_move = ai_pieces[rand(ai_pieces.length)]
			puts "Ai piece to move is #{board[piece_to_move].symbol} #{board[piece_to_move].position}"
			available_moves = board[piece_to_move].moves
			if available_moves.length > 0
				target = available_moves[rand(available_moves.length)]
				puts "target is #{target}"
				good = @board.move(piece_to_move, target, 'black')
				puts "#{piece_to_move} moved to #{target}" if good
			end
		end
		@board
	end

end
