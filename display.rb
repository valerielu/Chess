require_relative 'cursorable'
require 'colorize'
require_relative 'board'
require_relative 'chess'


class Display
  include Cursorable
  attr_accessor :selected

  def initialize(board)#, chess)
    @board = board
    # @chess = chess
    @cursor_pos = [7,0]
    @selected = false
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_blue
    elsif (i + j).odd?
      bg = :light_yellow
    elsif (i + j).even?
      bg = :yellow
    end
    # { background: bg, color: :black }
    { background: bg, color: @board[*[i, j]].color }
  end

  def render
    system("clear")
    puts "Play Chess!"
    puts "Hit space or enter to select a piece, arrow keys or WASD to move, space or enter again to drop the piece."
    build_grid.each { |row| puts row.join }
  end

  # def display
  #   grid.each do |row|
  #     # byebug
  #     puts row.map {|piece| piece.class}.join(' ')
  #   end
  # end
end
