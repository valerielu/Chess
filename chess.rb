require_relative 'player'
require_relative 'board'
require_relative 'display'

class Chess
  attr_reader :board

  def initialize
    @board = Board.new
    @human_player_1 = Player.new(@board)
    @human_player_2 = Player.new(@board)
    @display = Display.new(@board)
  end

  def run
    @board.populate!
    # until board.checkmate?(:black)# || board.checkmate?(:white)
    loop do
      pos1 = @human_player_1.play_turn
      board.move(board[*pos1[0]].move_dirs, pos1[0], pos1[1])
      pos2 = @human_player_2.play_turn
      board.move(board[*pos2[0]].move_dirs, pos2[0], pos2[1])
      @display.render
      break if board.checkmate?(:black) || board.checkmate?(:white)
    end

    puts "Somebody won! Loser buys pizza!!!"
  end
end


if __FILE__ == $PROGRAM_NAME
  Chess.new.run
end
