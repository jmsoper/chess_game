class Piece

  attr_reader :color

  def initialize(pos, board, color)
    @color = color
    @pos = pos
    @board = board
  end

end

class SlidingPiece < Piece
end

class SteppingPiece < Piece
end

class Pawn < Piece
end

class Rook < SlidingPiece
end

class Bishop < SlidingPiece
end

class Queen < SlidingPiece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end
