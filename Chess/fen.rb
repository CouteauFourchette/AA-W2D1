require_relative 'pieces'
require_relative 'board'

class Fen
  def initialize(fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    @fen_string = fen_string
  end

  def parse
    board = Board.new

    splited_fen = @fen_string.split(' ')
    pieces = splited_fen[0]

    rows = pieces.split('/')
    i = 0
    grid = []
    rows.each do |r|
      line = []
      j = 0
      r.each_char do |e|
        color = e.downcase == e ? :black : :white

        case e.downcase
        when 'p'
          line << Pawn.new(board, [i,j], color)
        when 'r'
          line << Rook.new(board, [i,j], color)
        when 'k'
          line << King.new(board, [i,j], color)
        when 'q'
          line << Queen.new(board, [i,j], color)
        when 'b'
          line << Bishop.new(board, [i,j], color)
        when 'n'
          line << Knight.new(board, [i,j], color)
        else
          num_empty = e.to_i
          line += [NullPiece.instance] * num_empty
          j += num_empty -1
        end
        j += 1
      end
      i += 1
      grid << line
    end
    # puts grid[6].count
    board.grid = grid

    next_player = splited_fen[1] == 'w' ? :white : :black

    [board, next_player]
  end
end

# Fen.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
