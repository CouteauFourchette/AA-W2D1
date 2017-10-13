require_relative 'piece'
require_relative 'stepable'

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
