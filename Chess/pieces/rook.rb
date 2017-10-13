require_relative 'piece'
require_relative 'slideable'

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
