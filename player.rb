require_relative 'display'

class Player
  attr_reader

  def initialize(board)#, chess)
    @display = Display.new(board)#, chess)
  end

  def play_turn
    result = []
    until result.size == 2
      @display.render
      is_selected = @display.selected
      input = @display.get_input
      if @display.selected && @display.selected != is_selected ||
        !@display.selected && @display.selected != is_selected
        result << input
      end
      result = [] if result[0] == result[1]
    end
    result
  end
end

class HumanPlayer
end
class ComputerPlayer
end
