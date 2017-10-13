require_relative 'piece'
require_relative 'slideable'

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
