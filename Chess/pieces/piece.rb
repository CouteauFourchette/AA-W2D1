require 'singleton'

class Piece
  attr_reader :symbol
  attr_accessor :color, :position
  attr_writer :board

  def initialize(board = nil, position = nil)
    @board = board
    @position = position
    @symbol = :empty
    @color = nil
  end

  def valid_moves
    m = moves.reject do |move|
      move_into_check?(move)
    end
    m
  end

  def move_into_check?(end_pos)
    new_board = @board.dup
    new_board[end_pos] = new_board[@position]
    new_board[@position] = NullPiece.instance
    new_board.in_check?(@color)
  end

  def to_s
    'Undefined'
  end

  def empty?
    @symbol == :empty
  end
end


class NullPiece < Piece
  include Singleton
  @color = :empty
end
