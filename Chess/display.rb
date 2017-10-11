require 'colorize'
require_relative 'cursor'


class Display
  def initialize(board = Board.create_new_board, cursor)
    @board = board
    @cursor = cursor
  end

  def render
    system('clear')
    (0..7).each do |i|
      (0..7).each do |j|
        e = @board[[i,j]]
        if @cursor.cursor_pos == [i,j]
          sym = !e.empty? ? "#{e.to_s.colorize(:red)} ".blink : '♢ '.colorize(:red)
        else
          sym = !e.empty? ? "#{e.to_s} " : '  '
        end
        if @cursor.selected == [i,j]
          sym = !e.empty? ? "#{e.to_s.colorize(:green)} " : '♢ '.colorize(:green)
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
