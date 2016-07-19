require_relative 'piece'
require_relative 'errors'
require 'byebug'

class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, piece)
    grid[row][col] = piece
  end

  def populate!
    grid.each_with_index do |row, i|
      if i == 0
        row.each_with_index do |col, j|
          case j
            when 0
              self[*[i, j]] = Rook.new([i, j], :black, self)
            when 1
              self[*[i, j]] = Knight.new([i, j], :black, self)
            when 2
              self[*[i, j]] = Bishop.new([i, j], :black, self)
            when 3
              self[*[i, j]] = Queen.new([i, j], :black, self)
            when 4
              self[*[i, j]] = King.new([i, j], :black, self)
            when 5
              self[*[i, j]] = Bishop.new([i, j], :black, self)
            when 6
              self[*[i, j]] = Knight.new([i, j], :black, self)
            when 7
              self[*[i, j]] = Rook.new([i, j], :black, self)
          end
        end
      elsif i == 7
        row.each_with_index do |col, j|
          case j
            when 0
              self[*[i, j]] = Rook.new([i, j], :white, self)
            when 1
              self[*[i, j]] = Knight.new([i, j], :white, self)
            when 2
              self[*[i, j]] = Bishop.new([i, j], :white, self)
            when 3
              self[*[i, j]] = Queen.new([i, j], :white, self)
            when 4
              self[*[i, j]] = King.new([i, j], :white, self)
            when 5
              self[*[i, j]] = Bishop.new([i, j], :white, self)
            when 6
              self[*[i, j]] = Knight.new([i, j], :white, self)
            when 7
              self[*[i, j]] = Rook.new([i, j], :white, self)
          end
        end
      elsif i == 1
        row.map!.with_index {|space, j| self[*[i, j]] = Pawn.new([i, j], :black, self)}
      elsif i == 6
        row.map!.with_index {|space, j| self[*[i, j]] = Pawn.new([i, j], :white, self)}
      else
        row.map!.with_index {|space, j| self[*[i, j]] = NullPiece.instance}
      end
    end
  end

  def move(directions, start_pos, end_pos)
    if self[*start_pos].class == NullPiece
      raise PieceError.new("Nothing at this position.")
    elsif !self[*start_pos].valid_move?(directions, start_pos, end_pos)
      raise PieceError.new("Cannot complete move.")
    end
    # logic for making the move if positions check out
  end


  def won?
    false
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end



end

b = Board.new
b.populate!
pawn = b[*[1,1]]
p pawn.all_moves(pawn.move_dirs)
p pawn.valid_move?(pawn.move_dirs, [2, 1])
p pawn.valid_move?(pawn.move_dirs, [1, 6])
p pawn.valid_move?(pawn.move_dirs, [1, 5])
