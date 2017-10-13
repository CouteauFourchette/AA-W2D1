require_relative 'piece'
require_relative 'stepable'

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
