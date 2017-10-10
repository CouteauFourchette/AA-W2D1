require_relative 'piece'

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8){Array.new(8, NullPiece.instance)}
    set_up
  end


  def inside_board?(pos)
    x,y = pos
    return false unless (0...8).cover?(x) && (0...8).cover?(y)
    true
  end

  def move_piece(start_pos, end_pos)
    unless self[start_pos].empty?
      raise ArgumentError.new("No piece at that position")
    end
    unless inside_board?(end_pos)
      raise ArgumentError.new("End position outside board")
    end
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  private
  def set_up
    pawns = ([1]*8 + [6]*8).zip((0..7).to_a*2)
    rooks = [[0,7],[7,0],[0,0],[7,7]]
    knights = [[0,1], [0,6], [7,1], [7,6]]
    bishops = [[0,2], [0,5], [7,2], [7,5]]
    queens = [[0,3],[7,3]]
    kings = [[0,4], [7,4]]
    (0...8).each do |i|
      (0...8).each do |j|
        pos= [i,j]
        case
        when pawns.include?(pos)
          self[pos] = Pawn.new(self, pos)
        when rooks.include?(pos)
          self[pos] = Rook.new(self, pos)
        when knights.include?(pos)
          self[pos] = Knight.new(self, pos)
        when bishops.include?(pos)
          self[pos] = Bishop.new(self, pos)
        when queens.include?(pos)
          self[pos] = Queen.new(self, pos)
        when kings.include?(pos)
          self[pos] = King.new(self, pos)
        else
          self[pos] = NullPiece.instance
        end
      end
    end
  end

end
