require "io/console"
require_relative 'history'

KEYMAP = {
  " " => :space,
  "1" => :one,
  "2" => :two,
  "3" => :three,
  "4" => :four,
  "5" => :five,
  "6" => :six,
  "7" => :seven,
  "8" => :eight,
  "a" => :a,
  "b" => :b,
  "c" => :c,
  "d" => :d,
  "e" => :e,
  "f" => :f,
  "g" => :g,
  "h" => :h,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board
  attr_accessor :selected

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = []
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key)
    key = key.to_sym
    file_system = [:a, :b, :c, :d, :e, :f, :g, :h]
    rank_system = [:one, :two, :three, :four, :five, :six, :seven, :eight]
    file_hash = Hash[file_system.zip (0...file_system.size)]
    rank_hash = Hash[rank_system.zip (0...rank_system.size)]

    case
    when key == :escape
      @selected = []
      nil
    when key == :return
      @cursor_pos
    when key ==:space
      @cursor_pos
    when file_hash.include?(key)
      set_pos([@cursor_pos[0], file_hash[key]])
      nil
    when rank_hash.include?(key)
      set_pos([7-rank_hash[key], @cursor_pos[1]])
      nil
    when MOVES.include?(key)
      update_pos(MOVES[key])
      nil
    when key == :ctrl_c
      History.instance.save_as_PGN
      Process.exit(0)
    end
  end


  def update_pos(diff)
    new_pos = [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
    if @board.inside_board?(new_pos)
      @cursor_pos = new_pos
      return new_pos
    end
  end

  def set_pos(pos)
    @cursor_pos = pos
  end
end
