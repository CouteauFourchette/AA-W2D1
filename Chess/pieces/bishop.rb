require_relative 'piece'
require_relative 'slideable'

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
