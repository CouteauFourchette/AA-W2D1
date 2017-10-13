module Slideable
  def moves
    possible_moves = []
    if move_dirs.include?(:lateral)
      lateral_diffs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
      possible_moves += possible_moves(lateral_diffs)
    end

    if move_dirs.include?(:diagonal)
      diagonal_diffs = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
      possible_moves +=  possible_moves(diagonal_diffs)
    end
    possible_moves
  end

  def possible_moves(diffs)
    possible_moves = []
    diffs.each do |diff|
      new_pos = [@position[0] + diff[0], @position[1] + diff[1]]
      line = []
      until !@board.inside_board?(new_pos)
        line << new_pos if (@board[new_pos].color != @color && @board.inside_board?(new_pos))

        break if !@board[new_pos].empty?
        new_pos = [new_pos[0] + diff[0], new_pos[1] + diff[1]]
      end
      possible_moves << line unless line.empty?
    end
    p possible_moves
    possible_moves.flatten(1)
  end
end
