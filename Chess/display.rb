require 'colorize'
require_relative 'board'
require_relative 'cursor'


class Display
  def initialize
    @board = Board.new
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
            print !e.empty? ? " #{e.to_s.colorize(:blue)}" : ' #'.colorize(:blue)
          else
            print !e.empty? ? " #{e.to_s.colorize(:red)}" : ' #'.colorize(:red)
          end
        else
          print !e.empty? ? " #{e.to_s}" : ' #'
        end
      end
      puts
    end
  end



end

d = Display.new
