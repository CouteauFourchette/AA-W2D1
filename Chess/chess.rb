require_relative 'fen'
require_relative 'pgn'
require_relative 'game'

if __FILE__ == $PROGRAM_NAME
  previous_arg = ''
  fen = Fen.new
  board = nil
  next_player = :white

  ARGV.each do |arg|

    if previous_arg == '--fen' || previous_arg == '-f'
      fen = Fen.new(arg)
      board, next_player = fen.parse
    elsif previous_arg == '--pgn' || previous_arg == '-p'
      pgn = Pgn.new(arg)
      board, next_player = pgn.load
    end

    previous_arg = arg
  end

  if board == 'someone_won'
    case next_player
    when '1-0'
      puts 'white wins (1-0)'
    when '0-1'
      puts 'black wins (1-0)'
    when '1/2-1/2'
      puts 'draw'
    end
  else

    board ||= Board.new

    game = Game.new('player1', 'player2', board, next_player)
    game.play
  end
end
