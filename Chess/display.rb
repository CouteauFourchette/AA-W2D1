require 'colorize'
require_relative 'cursor'
require_relative 'history'
require 'byebug'

class Display
  def initialize(board = Board.create_new_board, cursor)
    @board = board
    @cursor = cursor
    @history = History.instance
  end

  def render
    row_notation = [8,7,6,5,4,3,2,1]
    column_notation = ['a','b','c','d','e','f','g','h']

    system('clear')
    print "  "
    (0..7).each { |i| print "#{column_notation[i]} " }
    print "   Moves"
    puts
    (0..7).each do |i|
      print "#{row_notation[i]} "
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
      print "   #{@history[i]}"
      puts
    end
  end

  def update_history(piece, finish)
    column_notation = ['a','b','c','d','e','f','g','h']
    notation = piece.to_s
    notation += ' ' + column_notation[finish[1]] + (8-finish[0]).to_s
    @history.add(notation)
  end
end
