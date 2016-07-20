require 'singleton'
require_relative 'board'
require_relative 'errors'

class NullPiece
  include Singleton
  attr_reader :color, :pos

  def pos
    "tricked you"
  end

  def color
    nil
  end

  def to_s
    "   "
  end

end


class Piece
  attr_reader :color, :board
  attr_accessor :pos

  def horizontal_dir
    [[-1, 0], [0, 1], [1, 0], [0, -1]]
  end

  def diagonal_dir
    [[-1, 1], [1, -1], [1, 1], [-1, -1]]
  end

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def <=>(another_piece)
    if another_piece
      if another_piece.color.nil?
        -1
      elsif self.color != another_piece.color
        1
      else
        0
      end
    end
  end

  def valid_move?(directions, end_pos)
    moves = all_moves(directions)
    return true if moves.include?(end_pos)
    raise PieceError.new("Not a valid move!")
  end

  def within_bounds?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def same_color?(pos)
    self.color == board[*pos].color
  end



  def dup(board)
    self.class.new(self.pos, self.color, board)
  end


  def move_into_check?(new_pos)
    fake_board = board.deep_dup
    fake_board.move!(self.pos, new_pos)
    fake_board.in_check?(self.color)
  end

  def valid_moves
    self.all_moves(self.move_dirs).reject { |move| self.move_into_check?(move)}
  end

end


class SlidingPiece < Piece
  # attr_reader :board

  def all_moves(directions)
    results = []
    directions.each do |dx, dy|
      (1..7).each do |i|
        position = [self.pos[0] + dx*i, self.pos[1] + dy*i]
        next unless within_bounds?(position)
        if self.same_color?(position)
          break
        elsif board[*position].color
          results << position
          break
        else
          results << position
        end
      end
    end
    results
  end
end


class SteppingPiece < Piece
  def all_moves(directions)
    results = []
    directions.each do |dx, dy|
      position = [self.pos[0]+dx, self.pos[1]+dy]
      next unless within_bounds?(position)
      next if self.same_color?(position)
      results << position
    end
    results
  end
end

class Queen < SlidingPiece

  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def move_dirs
    horizontal_dir + diagonal_dir
  end

  def to_s
    " \u265b "
    # " Q  "
  end
end

class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def move_dirs
    diagonal_dir
  end

  def to_s
    " B "
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def move_dirs
    horizontal_dir
  end

  def to_s
    " R "
  end
end

class King < SteppingPiece

  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def move_dirs
    horizontal_dir + diagonal_dir
  end

  def to_s
    " K "
  end
end

class Knight < SteppingPiece

  def initialize(pos, color, board)
    super(pos, color, board)
  end

  def move_dirs
    [[-2, -1], [-2,  1], [-1, -2],
    [-1,  2], [ 1, -2], [ 1,  2],
    [ 2, -1], [ 2,  1]]
  end

  def to_s
    " N "
  end
end

class Pawn < Piece
  def initialize(pos, color, board)
    super(pos, color, board)
    @starting_pos = pos
  end

  def move_dirs
    move_dirs = if self.color == :black
      { forward: [1,0], first_move: [2,0], attack_left: [1,-1], attack_right: [1,1]}
    elsif self.color == :white
      { forward: [-1,0], first_move: [-2,0], attack_left: [-1,-1], attack_right: [-1,1]}
    end
  end

  def all_moves(directions)
    dirs = []
    if self.<=>(board[*[(self.pos[0] + directions[:attack_right][0]) ,(self.pos[1] + directions[:attack_right][1])]]) == 1
      dirs << directions[:attack_right]
    end

    if self.<=>(board[*[(self.pos[0] + directions[:attack_left][0]) ,(self.pos[1] + directions[:attack_left][1])]]) == 1
      dirs << directions[:attack_left]
    end

    if self.<=>(board[*[(self.pos[0] + directions[:forward][0]) ,(self.pos[1] + directions[:forward][1])]]) == -1
      dirs << directions[:forward]
    end

    if @starting_pos == self.pos && dirs.include?(directions[:forward])
      dirs << directions[:first_move]
    end
    results = []
    dirs.each do |dx,dy|
      position = [self.pos[0]+dx, self.pos[1]+dy]
      next unless within_bounds?(position)
      results << position
    end
    results
  end

  def to_s
    " P "
  end
end

#
# k = Knight.new([0,0], :black)
# p k.move_dirs
# b = Board.new
# b.populate!
# q = b[*[0,4]]
# q.all_moves(q.move_dirs, pos) # []
# q.valid_move?(q.move_dirs, pos, [1, 4]) #false
# q.all_moves(q.move_dirs, pos, )
