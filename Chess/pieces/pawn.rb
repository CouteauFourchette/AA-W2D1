require_relative 'piece'

class Pawn < Piece
  def initialize(*)
    super
    @symbol = :pawn
    @moved = false
  end

  def position=(pos)
    promotion = @color == :black ? 0 : 7
    puts pos.inspect
    raise PromotionException if pos[0] == promotion
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

class PromotionException < StandardError
end
