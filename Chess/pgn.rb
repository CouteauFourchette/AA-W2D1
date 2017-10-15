require_relative 'board'
require_relative 'display'

class Pgn
  def initialize(filename = nil, white = '?', black = '?')
    time = Time.new
    format_time = time.strftime("%Y-%m-%d-%H:%M:%S")
    filename ||= "games/#{format_time}.pgn"
    @filename = filename
    @information = {
      result: '*',
      date: time.strftime("%Y.%m.%d"),
      round: '1',
      event: '?',
      black: black,
      site: 'Earth',
      white: white
    }
  end

  def save(log)
    pgn_lines = []
    symbols = { '♔'=> 'K', '♚'=> 'K', '♗'=> 'B', '♝'=> 'B', '♘'=> 'N', '♞'=> 'N', '♙'=> '', '♟'=> '', '♕'=> 'Q', '♛'=> 'Q', '♖'=> 'R', '♜'=> 'R' }
    log.each do |line|
      symbols.each do |key, val|
        if line.include?(key)
          line = line.gsub(/#{key} */, val)
        end
      end
      pgn_lines << line
    end
    file = File.open(@filename, 'w')
    @information.each do |key, value|
      file.puts("[#{key.capitalize} \"#{value}\"]")
    end
    file.puts
    pgn_lines.reverse.each { |pgn| file.puts(pgn) }
    file.close
    puts "Game saved at #{@filename}"
  end

  def load
    lines = File.readlines(@filename)
    moves = []
    lines.each do |line|
      if line =~ /\[*\]/ #information
        key, value = line.split
        key = key[1..-1].downcase.to_sym
        @information[key] = value[1...-2]
      else # moves
        line = line.gsub /([0-9]+\.)/, ' ' #remove line number
        moves += line.split
      end
    end
    puts @information
    puts moves.inspect
    board = Board.create_new_board
    cursor = Cursor.new([6,4], board)
    display = Display.new(board, cursor)

    color = :white
    moves.each do |move|
      color = color == :white ? :black : :white
      if move == 'O-O' || move == 'O-O-O'
        castle(board, move, color)
      else
        play_move(board, move, color)
      end
      display.render
    end
  end

  private
  def play_move(board, move, color)
    move = move.sub('x', '')
    move = move.sub('+', '')
    end_pos = move.scan /[a-z][0-9]\z/
    move = move.gsub /[a-z][0-9]\z/, ''
    piece = move.scan /.*[A-Z]/
    move = move.gsub /.*[A-Z]/, ''
    pos = get_pos(end_pos[0])
    symbol = get_symbol(piece[0])

    pieces = board.grid.flatten.select do |piece|
      !piece.empty? &&
      piece.symbol == symbol &&
      piece.color == color &&
      piece.valid_moves.include?(pos)
    end
    if pieces.length > 1
      rank_notation = ['8','7','6','5','4','3','2','1']
      file_notation = ['a','b','c','d','e','f','g','h']


      pieces = pieces.select do |piece|
        file = move.scan /[a-z]/
        rank = move.scan /[0-9]/
        file = file.empty? ? piece.position[1] : file_notation.index(file[0])
        rank = rank.empty? ? piece.position[0] : rank_notation.index(rank[0])
        piece.position == [rank, file]
      end
    end
    board.move_piece(pieces[0].position, pos)
  end

  def castle(board, move, color)
    king = board.grid.flatten.find { |piece| !piece.empty? && piece.symbol == :king && piece.color == color }
    rank, file = king.position
    if move == 'O-O'
      board.move_piece([rank, file], [rank ,7])
    elsif move == 'O-O-O'
      board.move_piece([rank, file], [rank ,0])
    end
  end

  def get_symbol(letter)
    puts letter.inspect
    return :pawn if !letter
    pieces = {'N'=> :knight, 'Q'=> :queen, 'B'=> :bishop, 'K' => :king, 'R'=> :rook}
    pieces[letter]
  end

  def get_pos(notation)
    row_notation = [8,7,6,5,4,3,2,1]
    column_notation = ['a','b','c','d','e','f','g','h']
    file, rank = notation.split('')
    puts "[#{row_notation.index(rank.to_i)}, #{column_notation.index(file)}]"
    [row_notation.index(rank.to_i), column_notation.index(file)]
  end
end
