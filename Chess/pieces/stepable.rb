module Stepable
  def moves
    possible_moves = []
    moves = move_diffs
    moves.each do |diff|
      new_pos = [@position[0] + diff[0], @position[1] + diff[1]]
      possible_moves << new_pos if @board.inside_board?(new_pos) && @board[new_pos].color != @color
    end
    possible_moves
  end
end
