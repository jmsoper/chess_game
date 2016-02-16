
class Board
  # include Cursorable
  attr_reader :grid, :display

  def initialize
    @grid = Array.new(8){Array.new(8)}
  end


  def other_color(color)
    return "white" if color == "red"
    return "red" if color == "white"
  end

  def checkmate?(color)
    our_pieces = find_piece(color)
    if in_check?(color) && our_pieces.all?{|piece| piece.valid_moves.empty?}
      return true
    end
    false
  end

  def in_check?(color)
    king_pos = find_piece(color, King).first.pos
    super_array = find_piece(other_color(color)).map {|piece| piece.moves}.flatten(1)
    if super_array.include?(king_pos)

      return true
    end
    false
  end

  def find_piece(color, piece_class = Piece)
    array_of_pieces = []
    self.grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        piece = self[row_index, col_index]
        if piece.is_a?(piece_class) && piece.color == color
          array_of_pieces << piece
        end
      end
    end
    array_of_pieces
  end

  def occupied?(row, col)
    !self[row, col].nil?
  end

  def in_bounds?(pos)
    [*pos].all?{|location| location >= 0 && location <= 7}
  end

  def move
    start, end_pos = @display.get_move_input
    raise ChessError.new ("There's no piece there.") if self[*start].nil?
    raise ChessError.new ("You can't land on your friend.") if occupied?(*end_pos) && !self[*start].other_color?(*end_pos)
    raise ChessError.new ("That's not a legal move for this piece.") unless self[*start].moves.include?(end_pos)

    this_piece = self[*start]
    this_piece.pos = end_pos
    self[*end_pos] = this_piece
    self[*start] = nil

  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, piece)
    @grid[row][col] = piece
  end

  def print_board
    @display = Display.new(self)
    @display.show_board
  end

  def set_board
    self[0,0] = Rook.new([0,0], self, "red")
    self[0,1] = Knight.new([0,1], self, "red")
    self[0,2] = Bishop.new([0,2], self, "red")
    self[0,3] = Queen.new([0,3], self, "red")
    self[0,4] = King.new([0,4], self, "red")
    self[0,5] = Bishop.new([0,5], self, "red")
    self[0,6] = Knight.new([0,6], self, "red")
    self[0,7] = Rook.new([0,7], self, "red")
    8.times do |i|
      self[1,i] = Pawn.new([1,i], self, "red")
    end

    8.times do |i|
      self[6,i] = Pawn.new([6,i], self, "white")
    end
    self[7,0] = Rook.new([7,0], self, "white")
    self[7,1] = Knight.new([7,1], self, "white")
    self[7,2] = Bishop.new([7,2], self, "white")
    self[7,3] = Queen.new([7,3], self, "white")
    self[7,4] = King.new([7,4], self, "white")
    self[7,5] = Bishop.new([7,5], self, "white")
    self[7,6] = Knight.new([7,6], self, "white")
    self[7,7] = Rook.new([7,7], self, "white")

  end

end


class ChessError < StandardError
end
