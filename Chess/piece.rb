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

  def valid_moves
    []
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
    @moved = false
  end

  def position=(pos)
    @moved = true
    @position = pos
  end

  def moves
    moves = @moved ? [[1,0]] : [[1,0], [2,0]]
    attacks = [[1,1], [1,-1]]

    positions = []
    moves.each do |move|
      x, y = move
      x = -x if @color == :black
      new_pos = [@position[0] + x, @position[1] + y]
      break if !@board.inside_board?(new_pos) || !@board[new_pos].empty?
      positions << new_pos
    end

    attacks.each do |attack|
      x, y = attack
      x = -x if @color == :black
      new_pos = [@position[0] + x, @position[1] + y]
      if @board.inside_board?(new_pos) && !@board[new_pos].empty? && @board[new_pos].color != @color
        positions << new_pos
      end
    end
    positions
  end

  def to_s
    @color == :white ? '♙' : '♟'
  end
end

class NullPiece < Piece
  include Singleton
  @color = :empty
end
