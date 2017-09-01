require_relative "board.rb"

class Ai 

	def initialize
		@board = Board.new
	end

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
				puts "ai pieces #{piece.to_s} #{@board.board[piece].symbol} with move: #{@board.board[piece].moves.to_s}"
			end
			piece_to_move = ai_pieces[rand(ai_pieces.length)]
			puts "Ai piece to move is #{board[piece_to_move].symbol} #{board[piece_to_move].position}"
			available_moves = board[piece_to_move].moves
			puts "available moves are #{available_moves}"
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
