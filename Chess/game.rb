
# while true
#   render
#   pos = @cursor.get_input
#   if pos && !@board[pos].is_a?(NullPiece)
#     @cursor.toggle_selected
#   end
# end
require_relative 'human_player'
require_relative 'display'
require_relative 'board'

class Game
  def initialize(name1, name2)
    @board = Board.create_new_board
    @cursor = Cursor.new([0,0], @board)
    @player1 = HumanPlayer.new(name1, :white, @cursor)
    @player2 = HumanPlayer.new(name2, :black, @cursor)
    @current_player = @player1
    @display = Display.new(@board, @cursor)
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play
    @display.render

    until @board.checkmate?(:black) || @board.checkmate?(:white)
      play_turn
    end
    puts "WINNNER IS #{@current_player.name}"
  end

  def play_turn


    @display.render
    pos = @current_player.get_input

    if pos != nil && !@cursor.selected.empty?
      @board.move_piece(@cursor.selected, pos)
      @cursor.selected = []
      switch_player
      @display.render

    elsif pos!=nil && @board[pos].color == @current_player.color && @cursor.selected.empty?
      @cursor.selected = pos
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new('a', 'b')
  game.play
end
