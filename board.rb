require_relative 'piece'
require_relative 'display'
require "colorize"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8){Array.new(8)}
    set_board
  end

  def move(start, end_pos)
    if self[*start].nil?
      raise "There's no piece there."
    end
    this_piece = self[*start]
    if !self[*end_pos].nil? && this_piece.color == self[*end_pos].color
      raise "You can't land on your friend."
    end
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


board = Board.new
board.print_board
