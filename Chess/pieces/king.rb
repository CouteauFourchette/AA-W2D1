require_relative 'piece'
require_relative 'stepable'


class CastleException < StandardError
end

class King < Piece
  include Stepable
  def initialize(*)
    super
    @symbol = :king
    @moved = false
  end

  def position=(pos)
    raise CastleException if !@moved && (pos == [0,0] || pos == [0,7])
    @moved = true
    @position = pos
  end

  def move_diffs
    [0,1,-1].permutation(2).to_a + [[1,1],[-1,-1]]
  end

  def castle
    return [] if @moved
    left = (1...@position[1]).all? do |i|
      @board[[0,i]].empty?
    end

    if left
      rook = @board[[0,0]]
      left = (rook.symbol == :rook && !rook.moved)
    end

    right = (@position[1]+1...7).all? do |i|
      @board[[0,i]].empty?
    end

    if right
      rook = @board[[0,7]]
      right = (rook.symbol == :rook && !rook.moved)
    end

    moves = []
    moves += [0,0] if left
    moves += [0,7] if right

    moves
  end

  def valid_moves
    normal_moves = super.dup
    normal_moves << castle
  end

  def to_s
    @color == :white ? '♔' : '♚'
  end
end
