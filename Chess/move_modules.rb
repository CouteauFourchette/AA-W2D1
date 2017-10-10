require 'byebug'
module Stepable

end

module Slideable
  def move(end_pos)

    possible_positions = []

    if move_dirs.include?(:lateral)
      lateral_diffs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
      line = line_moves(end_pos, lateral_diffs)
    end

    if move_dirs.include?(:diagonal)
      diagonal_diffs = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
      line ||= line_moves(end_pos, diagonal_diffs)
    end

    puts line
  end

  def line_moves(end_pos, diffs)
    puts diff
    diffs.each do |diff|
      new_pos = [end_pos[0] + diff[0], end_pos[1] + diff[1]]
      line = []
      until !@board.inside_board?(new_pos)
        line << new_pos
        new_pos = [new_pos[0] + diff[0], new_pos[1] + diff[1]]
      end
      return line if line.include?(end_pos)
    end
    nil
  end

end
