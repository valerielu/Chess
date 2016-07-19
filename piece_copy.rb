require 'singleton'
class NullPiece
  include Singleton
  def color
  end

  def to_s
    "   "
  end

end


class Piece
  attr_reader :color, :board

  def horizontal_dir
    [[-1, 0], [0, 1], [1, 0], [0, -1]]
  end

  def diagonal_dir
    [[-1, 1], [1, -1], [1, 1], [-1, -1]]
  end

  def knight_dir
    [[-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]]
  end

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def valid_move?(start_pos, end_pos, color, all_moves)
    all_pos = add_diffs(start_pos, all_moves)
    within = within_bounds(all_pos)
    raise PieceError.new "Not within bounds!" unless within.include?(end_pos)

    # raise error or rescue(?) if another of one's piece at the location

  end

  def add_diffs(pos, all_moves)
    all_moves.map { |dx, dy| dx,dy = pos[0]+dx, pos[1]+dy }
  end

  def within_bounds(array)
    array.select { |x,y| x.between?(0,7) && y.between?(0,7) }
  end

  def same_color?(pos)
    self.color == board[*pos].color
  end



  # def possible_moves(moves_dir)
  #   possible = []
  #
  #   cur_x, cur_y = pos
  #   moves_dir.each do |(dx, dy)|
  #     new_pos = [cur_x + dx, cur_y + dy]
  #     if new_pos.all? { |coord| coord.between?(0, 7) }
  #       possible << new_pos
  #     end
  #   end
  #   possible
  # end


end

class SlidingPiece < Piece

  def all_moves(directions)
    results = []
    directions.each do |direction|
      (1..7).each do |i|
        results << [direction[0]*i, direction[1]*i]
      end
    end
    results
  end

  def not_blocked(start_pos, within)
    within.select do |pos|
      select? = false
      diff = [pos[0] - start_pos[0], pos[1] - start_pos[1]]
      dir = diff.map {|coord| coord / diff.max}
      in_line = []
      diff.max.times do
        in_line << [start_pos[0]+dir[0], start_pos[1]+dir[1]]
      end
      in_line.each do |current|
        if board.[*current].color.nil?
          select? = true
        elsif !current.same_color?(start_pos)
          select? = true
        end
      end
      select?
    end
  end



  def valid_move?(start_pos, end_pos, color, all_moves)
    all_pos = add_diffs(start_pos, all_moves)
    within = within_bounds(all_pos)
    raise PieceError.new "Not within bounds!" unless within.include?(end_pos)
    not_blocked(start_pos, within)
    # raise error or rescue(?) if another of one's piece at the location

  end

  def add_diffs(pos, all_moves)
    all_moves.map { |dx, dy| dx,dy = pos[0]+dx, pos[1]+dy }
  end

  def within_bounds(array)
    array.select { |x,y| x.between?(0,7) && y.between?(0,7) }
  end

  def same_color?(pos)
    self.color == board[*pos].color
  end

  def

end


class SteppingPiece < Piece

end

class Queen < SlidingPiece

  def initialize(pos, color)
    super(pos, color)
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
  def initialize(pos, color)
    super(pos, color)
  end

  def move_dirs
    diagonal_dir
  end

  def to_s
    " B "
  end
end

class Rook < SlidingPiece
  def initialize(pos, color)
    super(pos, color)
  end

  def move_dirs
    horizontal_dir
  end

  def to_s
    " R "
  end
end

class King < SteppingPiece

  def initialize(pos, color)
    super(pos, color)
  end

  def move_dirs
    horizontal_dir + diagonal_dir
  end

  def to_s
    " K "
  end
end

class Knight < SteppingPiece

  def initialize(pos, color)
    super(pos, color)
  end

  def move_dirs
    knight_dir
  end

  def to_s
    " N "
  end
end

class Pawn < Piece
  def initialize(pos, color)
    super(pos, color)
  end

  def move_dirs

  end

  def to_s
    " P "
  end
end

#
# k = Knight.new([0,0], :black)
# p k.move_dirs
q = Queen.new([0,0], :black)
p q.all_moves(q.move_dirs).length
p q.all_moves(q.move_dirs)
