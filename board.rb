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


  def find_king(color)
    grid.each do |row|
      row.each do |col|
        return col if (col.class == King && col.color == color)
      end
    end
  end


  def in_check?(color)
    king = find_king(color)
    opponent_moves = []
    grid.each do |row|
      row.each do |piece|
        opponent_moves += piece.all_moves(piece.move_dirs) if
        (piece.color && (king.color != piece.color))
      end
    end

    opponent_moves.include?(king.pos)
  end

  def checkmate?(color)
    puts "YOURE DONE"
    in_check?(color) && find_king(color).valid_moves.empty?
  end


  def deep_dup
    fake_board = Board.new
    fake_board.grid.map!.with_index do |row, i|
      row.map!.with_index do |piece, j|
        if self[*[i,j]].class == NullPiece
          NullPiece.instance
        else
          self[*[i,j]].dup(fake_board)
        end
      end
    end
    fake_board
  end

  def move!(start_pos, end_pos)
    self[*end_pos] = self[*start_pos]
    self[*start_pos] = NullPiece.instance
  end

  def move(directions, start_pos, end_pos)
    if self[*start_pos].class == NullPiece
      raise PieceError.new("Nothing at this position.")
    elsif !self[*start_pos].valid_move?(directions, end_pos)
      raise PieceError.new("Cannot complete move.")
    elsif !self[*start_pos].valid_moves.include?(end_pos)
      raise PieceError.new("Move puts you in check.")
    end
    move!(start_pos, end_pos)
  end

  # for cursor
  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end



end

b = Board.new
b.populate!
# p b.find_king(:white).color
# pawn = b[*[1,0]]
# b.move!([1,0], [2, 0])
