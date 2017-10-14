require_relative 'pieces'
require_relative 'History'

class Board
  attr_reader :grid
  def initialize(grid = Array.new(8){Array.new(8)})
    @grid = grid
    @history = History.instance
  end

  def dup
    new_grid = deep_dup(@grid)
    new_board = Board.new(new_grid)
    new_board.grid.each do |row|
      row.each do |piece|
        piece.board = new_board
      end
    end
    new_board
  end

  def inside_board?(pos)
    x,y = pos
    return false unless (0...8).cover?(x) && (0...8).cover?(y)
    true
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].empty?
      raise ArgumentError.new("No piece at that position")
    end
    unless inside_board?(end_pos)
      raise ArgumentError.new("End position outside board")
    end
    unless self[start_pos].valid_moves.include?(end_pos)
      raise ArgumentError.new("Invalid move")
    end
    if self[start_pos].move_into_check?(end_pos)
      raise ArgumentError.new("Moving into check")
    end

    begin
      attack = !self[end_pos].empty?
      initial_board = dup
      start_piece = self[start_pos].dup
      old_piece = self[end_pos].dup unless self[end_pos].empty?
      self[end_pos] = self[start_pos].dup
      self[end_pos].position = end_pos

    rescue CastleException
      if end_pos[1] == 7
        king_pos = [start_pos[0], start_pos[1] + 2]
        rook_pos = [end_pos[0], end_pos[1] - 2]
        @history.castling(:kingside)
      else
        king_pos = [start_pos[0], start_pos[1] - 2]
        rook_pos = [end_pos[0], end_pos[1] + 3]
        @history.castling(:queenside)
      end
      self[king_pos] = self[end_pos].dup
      self[king_pos].position = king_pos
      self[end_pos] = NullPiece.instance
      self[rook_pos] = old_piece.dup
      old_piece.position = rook_pos
    else

      if attack
        @history.takes(start_piece, end_pos, initial_board, self)
      else
        @history.moves(start_piece, end_pos, initial_board, self)
      end

    ensure
      self[start_pos] = NullPiece.instance
    end

    self[end_pos]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def in_check?(color)
    king = []
    opposing_pieces = []
    @grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        king = [i,j] if piece.symbol == :king && piece.color == color
        opposing_pieces << piece if !piece.empty? && piece.color != color
      end
    end
    opposing_pieces.any? { |piece| piece.moves.include?(king) }
  end

  def checkmate?(color)
    return false unless in_check?(color)
    @grid.each do |row|
      row.each do |piece|
        if !piece.empty? && piece.color == color
          return false unless piece.valid_moves.empty?
        end
      end
    end
    true
  end

  def self.create_new_board
    new_board = Board.new
    new_board.set_up
    new_board
  end

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

        #Color the pieces
        unless self[pos].empty?
          (i == 0 || i == 1) ? self[pos].color = :white : self[pos].color = :black
        end

      end
    end
  end

  private

  def deep_dup(arr)
    return arr if arr.is_a?(NullPiece)
    return arr.dup if !arr.is_a?(Array)
    arr.map{|el| deep_dup(el)}
  end


end
