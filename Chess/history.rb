require 'singleton'

class History
  include Singleton

  def initialize()
    @log = []
  end

  def add(item)
    if @log[0] && @log[0].length < 6
      @log[0] += '  ' + item
    else
      @log.unshift(item)
    end
  end

  def [](item)
    @log[item]
  end

end
