require_relative 'piece'
require_relative 'display'
# require_relative 'cursorable'
require "colorize"
require 'byebug'

class Board
  # include Cursorable
  attr_reader :grid, :display

  def initialize
    @grid = Array.new(8){Array.new(8)}
    set_board
  end

  def play
    until false
    begin
      move
    rescue ChessError => e
      puts e.message
      sleep(2)
      retry
    ensure
      system("clear")
      print_board
    end
  end
end

  def occupied?(row, col)
    !self[row, col].nil?
  end

  def in_bounds?(pos)
    [*pos].all?{|location| location >= 0 && location <= 7}
  end

  def move
    # debugger
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
    self[7,3] = King.new([7,3], self, "white")
    self[7,4] = Queen.new([7,4], self, "white")
    self[7,5] = Bishop.new([7,5], self, "white")
    self[7,6] = Knight.new([7,6], self, "white")
    self[7,7] = Rook.new([7,7], self, "white")

  end

end


class ChessError < StandardError
end


board = Board.new
board.print_board
board.play
