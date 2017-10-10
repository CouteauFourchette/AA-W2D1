require 'colorize'
require_relative 'board'
require_relative 'cursor'


class Display
  def initialize
    @board = Board.create_new_board
    @cursor = Cursor.new([0,0], @board)

    while true
      render
      pos = @cursor.get_input
      if pos && !@board[pos].is_a?(NullPiece)
        @cursor.toggle_selected
      end
    end

  end

  def render
    system('clear')
    (0..7).each do |i|
      (0..7).each do |j|
        e = @board[[i,j]]
        if @cursor.cursor_pos == [i,j]

          if @cursor.selected
            sym = !e.empty? ? "#{e.to_s.colorize(:green)} " : '♢ '.colorize(:green)
          else
            sym = !e.empty? ? "#{e.to_s.colorize(:red)} ".blink : '♢ '.colorize(:red)
          end
        else
            sym = !e.empty? ? "#{e.to_s} " : '  '
        end
        if (i % 2 == 0 && j % 2 == 0) || (i % 2 != 0 && j % 2 != 0)
          print sym.on_light_blue
        else
          print sym
        end
      end
      puts
    end
  end



end

d = Display.new
