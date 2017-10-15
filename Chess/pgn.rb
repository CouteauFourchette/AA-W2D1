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
    symbols = { '♔ '=> 'K', '♚ '=> 'K', '♗ '=> 'B', '♝ '=> 'B', '♘ '=> 'N', '♞ '=> 'N', '♙ '=> ' ', '♟ '=> ' ', '♕ '=> 'Q', '♛ '=> 'Q', '♖ '=> 'R', '♜ '=> 'R' }
    log.each do |line|
      symbols.each do |key, val|
        if line.include?(key)
          line = line.sub(key, val)
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
    lines.each do |line|
      if line =~ /\[*\]/ #information
        key, value = line.split
        key = key[1..-1].downcase.to_sym
        @information[key] = value[1...-2]
      else # moves
        line = line.gsub /([0-9]+\.)/, ' ' #remove line number
        puts line.split
      end
    end
    puts @information

  end
end
