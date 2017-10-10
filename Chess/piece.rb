require 'singleton'
require_relative 'move_modules'

class Piece
  attr_reader :symbol
  attr_accessor :color, :position

  def initialize(board = nil, position = nil)
    @board = board
    @position = position
    @symbol = :empty
    @color = nil
  end

  def to_s
    'Undefined'
  end

  def empty?
    @symbol == :empty
  end
end

class King < Piece
  include Stepable
  def initialize(*)
    super
    @symbol = :king
  end

  def move_diffs
    [0,1,-1].permutation(2).to_a + [[1,1],[-1,-1]]
  end

  def to_s
    @color == :white ? '♔' : '♚'
  end
end

class Knight < Piece
  include Stepable
  def initialize(*)
    super
    @symbol = :knight
  end

  def move_diffs
   [[-1, 2],[-1, -2],[1, 2],[1, -2],[2, -1],[2, 1],[-2, -1],[-2, 1]]
  end

  def to_s
    @color == :white ? '♘' : '♞'
  end

end

class Bishop < Piece
  include Slideable
  def initialize(*)
    super
    @symbol = :bishop
  end

  def to_s
    @color == :white ? '♗' : '♝'
  end

  def move_dirs
    [:diagonal]
  end
end

class Rook < Piece
  include Slideable
  def initialize(*)
    super
    @symbol = :rook
  end

  def to_s
    @color == :white ? '♖' : '♜'
  end

  def move_dirs
    [:lateral]
  end
end

class Queen < Piece
  include Slideable
  def initialize(*)
    super
    @symbol = :queen
  end

  def to_s
    @color == :white ? '♕' : '♛'
  end

  def move_dirs
    [:lateral, :diagonal]
  end
end

class Pawn < Piece
  def initialize(*)
    super
    @symbol = :pawn
  end

  def to_s
    @color == :white ? '♙' : '♟'
  end
end

class NullPiece < Piece
  include Singleton
  @color = :empty
end
