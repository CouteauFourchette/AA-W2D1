class Pgn
  def initialize
    time = Time.new
    format_time = time.strftime("%Y-%m-%d-%H:%M:%S")
    @filename = "games/#{format_time}.pgn"
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
    file.puts('[Result "*"]')
    file.puts('[Date "2017.10.14"]')
    file.puts('[Round "1"]')
    file.puts('[Event "?"]')
    file.puts('[Black "?"]')
    file.puts('[Site "Earth"]')
    file.puts('[White "?"]')
    file.puts
    pgn_lines.reverse.each { |pgn| file.puts(pgn) }
    file.close
  end

  def load
    
  end
end
