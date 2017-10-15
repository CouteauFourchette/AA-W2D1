require 'singleton'
require_relative 'pgn'

class History
  include Singleton

  FILE_NOTATION = ['a','b','c','d','e','f','g','h']
  RANK_NOTATION = ['8','7','6','5','4','3','2','1']

  def initialize()
    @log = []
    @line_count = 1
  end

  def takes(piece, end_pos, begin_board, end_board)
    notation = piece.to_s
    rank, file = end_pos
    notation += check_same_pieces(piece, end_pos, begin_board)
    notation += 'x' + FILE_NOTATION[file] + RANK_NOTATION[rank]
    notation += '+' if check?(piece, end_board)
    add(notation)
  end

  def moves(piece, end_pos, begin_board, end_board)
    notation = piece.to_s
    rank, file = end_pos
    notation += check_same_pieces(piece, end_pos, begin_board)
    notation += FILE_NOTATION[file] + RANK_NOTATION[rank]
    notation += '+' if check?(piece, end_board)
    add(notation)
  end

  def castling(side)
    if side == :kingside
      add('O-O')
    elsif side == :queenside
      add('O-O-O')
    end
  end

  def check?(piece, board)
    ennemy_color = piece.color == :white ? :black : :white
    board.in_check?(ennemy_color)
  end

  def check_same_pieces(piece, finish, board)
    similar_pieces = []
    board.grid.each do |row|
      row.each do |o_piece|
        if o_piece.position != piece.position && o_piece.color == piece.color && o_piece.symbol == piece.symbol
          similar_pieces << o_piece
        end
      end
    end
    other_pieces = similar_pieces.select { |pie| pie.valid_moves.include?(finish)}
    return ' ' if other_pieces.empty?
    differentiate_pieces(piece, other_pieces)
  end

  def differentiate_pieces(main_piece, other_pieces)
    rank, file = main_piece.position
    same_file = other_pieces.any? do |o_piece|
       o_piece.position[1] == file
    end
    return " #{FILE_NOTATION[file]}" unless same_file
    same_rank = other_pieces.any? do |o_piece|
       o_piece.position[0] == rank
    end
    return " #{RANK_NOTATION[rank]}" unless same_rank
    return " #{FILE_NOTATION[file]}#{RANK_NOTATION[rank]}"
  end

  def [](item)
    @log[item]
  end

  def save_as_PGN
    pgn = Pgn.new
    pgn.save(@log)
  end

  private
  def add(item)
    if @log[0] && @log[0].length < 10
      @log[0] += ' ' + item
    else
      @log.unshift("#{@line_count}.#{item}")
      @line_count += 1
    end
  end

end
