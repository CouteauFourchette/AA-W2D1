require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  attr_reader :moved

  include Slideable
  def initialize(*)
    super
    @symbol = :rook
    @moved = false
  end

  def position=(pos)
    @moved = true
    @position = pos
  end

  def to_s
    @color == :white ? '♖' : '♜'
  end

  def move_dirs
    [:lateral]
  end
end
