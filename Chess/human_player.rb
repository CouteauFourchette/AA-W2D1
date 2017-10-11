class HumanPlayer
  attr_reader :color, :name

  def initialize(name, color, cursor)
    @name, @color, @cursor = name, color, cursor
  end

  def get_input
    begin
      @cursor.get_input

    rescue
      retry
    end
  end
end
