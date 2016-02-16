class Piece
  attr_reader :color,:board
  attr_accessor :pos

  def initialize(pos, board, color)
    @color = color
    @pos = pos
    @board = board
    @directions = []
  end

  def inspect
    [@color, @pos, self.class]
  end

  #moves returns an array of viable moves from a given position.
  def moves
  end

  def valid_moves
    moves.reject{ |move| move_into_check?(move) }
  end


  def move_into_check?(end_pos)
    check_board = dup_board

    start = self.pos
    self.pos = end_pos
    check_board[*end_pos] = self
    check_board[*start] = nil
    check_board.in_check?(@color)
  end

  def dup_board
    dup_board = Board.new
    @board.grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        original_piece = @board[row_index, col_index]
        if original_piece.nil?
          dup_piece = nil
        else
         dup_piece = original_piece.dup
         dup_board[row_index, col_index] = dup_piece
       end
      end
    end
    dup_board
  end

  #other_color? checks if an occupied position is occupied by a piece from the other taem
  def other_color?(row, col)
    self.color != @board[row, col].color
  end

  #invalid? checks if a location is off the board or else occupied by a piece of either color
  def invalid?(row, col)
    !@board.in_bounds?([row, col]) || @board.occupied?(row, col) #let's write this!
  end


end



class SlidingPiece < Piece
DIRECTIONS = [ up = Proc.new{ |row, col| [row - 1, col] },
              down = Proc.new{ |row, col| [row + 1, col] },
              left = Proc.new{ |row, col| [row, col - 1] },
              right = Proc.new{ |row, col| [row, col + 1] },
              leftup = Proc.new{ |row, col| [row - 1, col - 1] },
              leftdown = Proc.new{ |row, col| [row + 1, col - 1] },
              rightup = Proc.new{ |row, col| [row - 1, col + 1] },
              rightdown = Proc.new{ |row, col| [row + 1, col + 1] }
            ]

  def initialize(pos, board, color)
    super(pos,board,color)
    @directions = DIRECTIONS
  end

  #returns the array of moves valid in any given sliding direction; will be all the positions along
  #any given axis/ direction until the edge of the board or another piece (it'll include that last one
  #if the other piece is on the other team, aka something we could attack; else will not include.)
  def moves
    row, col = self.pos
    move_dirs(row, col)
  end

  #subset/ helper method of moves that is specific to sliding pieces.
  def move_dirs(row, col)
    directional_moves = []

    @directions.each do |direction|
      new_row, new_col = direction.call(row, col)
      until invalid?(new_row, new_col)
        directional_moves << [new_row, new_col]
        new_row, new_col = direction.call(new_row, new_col)
      end
      if @board.in_bounds?([new_row, new_col]) && other_color?(new_row, new_col)
        directional_moves << [new_row, new_col]
      end
    end

    return directional_moves
  end

end


class Rook < SlidingPiece
  def initialize(pos, board, color)
    super(pos,board,color)
    @directions = DIRECTIONS[0..3]
  end

end

  #can call move_dirs from super without even calling it; we can call move_dirs from within other methods in our
  #class, like when we are building arrays of valid moves-- without having to define move_dirs
  #anew in this class.



class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos,board,color)
    @directions = DIRECTIONS[4..7]
  end
end

class Queen < SlidingPiece
end


class SteppingPiece < Piece
  def invalid?(row, col)
    !@board.in_bounds?([row, col]) || (@board.occupied?(row, col) && !other_color?(row,col))#let's write this!
  end

end


class Knight < SteppingPiece
  KNIGHT_DELTAS = [[-2, -1],[-2, 1],[2, -1],[2, 1],[-1, -2],[1, -2],[-1, 2],[1, 2]]

  def moves
    row, col = self.pos
    available_moves = KNIGHT_DELTAS.map{ |delta| [delta[0] + row, delta[1] + col] }
    available_moves.reject {|row,col| invalid?(row,col)}
  end
end

class King < SteppingPiece
  KING_DELTAS = [[1, 0], [1, 1], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]

  def moves
    row, col = self.pos
    available_moves = KING_DELTAS.map{ |delta| [delta[0] + row, delta[1] + col] }.reject {|row,col| invalid?(row,col)}
  end
end




class Pawn < Piece
  RED_ATTACKS = [[1,-1], [1,1]]
  WHITE_ATTACKS = [[-1, -1], [-1, 1]]

  def moves
    row, col = self.pos
    if self.color == "red"
      available_moves = [[(1 + row), col]]
      available_moves << [(2 + row), col] if row == 1
      RED_ATTACKS.each do |attack|
        attack_row, attack_col = attack
        available_moves << [attack_row + row, attack_col + col] if valid_attack?(attack_row + row, attack_col + col)
      end
    else
      available_moves = [[(row - 1), col]]
      available_moves << [(row - 2), col] if row == 6
      WHITE_ATTACKS.each do |attack|
        attack_row, attack_col = attack
        available_moves << [attack_row + row, attack_col + col] if valid_attack?(attack_row + row, attack_col + col)
      end
    end
    available_moves
  end

  def valid_attack?(row, col)
    @board.occupied?(row, col) && other_color?(row, col)
  end

end
