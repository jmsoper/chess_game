class Piece

  attr_reader :color,:board

  attr_accessor :pos

  def initialize(pos, board, color)
    @color = color
    @pos = pos
    @board = board
  end

  def moves
    # call allowed?()
    [] #probably return an array of viable moves.
  end

  def allowed?(pos)
    if @board[pos].color == self.color
      puts "You can't land on your friend."
      return false
    else
      return true
    end
  end

end



class SlidingPiece < Piece

#rook would be DIRECTIONS[0..3]; bishop would be DIRECTIONS[4..7]; queen is all.
DIRECTIONS = [ up = Proc.new{ |row, col| [row - 1, col] },
              down = Proc.new{ |row, col| [row + 1, col] },
              left = Proc.new{ |row, col| [row, col - 1] },
              right = Proc.new{ |row, col| [row, col + 1] },
              leftup = Proc.new{ |row, col| [row - 1, col - 1] },
              leftdown = Proc.new{ |row, col| [row + 1, col - 1] },
              rightup = Proc.new{ |row, col| [row - 1, col + 1] },
              rightdown = Proc.new{ |row, col| [row + 1, col + 1] }
            ]


  def move_dirs(row, col, directions = @directions)
    directional_moves = []

    DIRECTIONS.each do |direction|
      new_row, new_col = direction.call(row, col)
      until invalid?(new_row, new_col)
        directional_moves << [new_row, new_col]
        new_row, new_col = direction.call(new_row, new_col)
      end
      directional_moves << [new_row, new_col] if @board[new_row, new_col].color != self.color

    end

    return directional_moves
  end

  def other_color?(row, col)
    self.color != @board[row, col].color
  end


  def invalid?(row, col) #need to also trigger this when there is a piece in the way.
    !@board.in_bounds(row, col)
    @board.occupied?(row, col) #let's write this!
  end

end


class Rook < SlidingPiece
  @directions  = DIRECTIONS[0..3]
  #can call move_dirs from super without even calling it; we can call move_dirs from within other methods in our
  #class, like when we are building arrays of valid moves-- without having to define move_dirs
  #anew in this class.

end

class Bishop < SlidingPiece
  @directions = DIRECTIONS[4..7]
end

class Queen < SlidingPiece
  @directions = DIRECTIONS
end




class SteppingPiece < Piece
end

class Pawn < Piece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end
