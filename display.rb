require 'byebug'
require_relative 'cursorable'

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
  end

  def make_a_move
    system("clear")
    show_board
    start = nil
    end_pos = nil
    until start
      puts "Tell us the starting position by hitting enter  on it."
      start = get_input
      system("clear")
      show_board
    end
    until end_pos
      puts "Tell us the ending position by hitting enter  on it."
      end_pos = get_input
      system("clear")
      show_board
    end
      @board.move(start, end_pos)
      system("clear")
      show_board
  end

  def set_background(piece = nil, i,j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    unless piece.nil?
      {background: bg, color: piece.color.to_sym}
    else
      {background: bg}
    end
  end

  def show_board
    puts "  A  B  C  D  E  F  G  H"
    @board.grid.each_with_index do |row, row_idx|
      print row_idx
      row.each_with_index do |piece, index|
        #  debugger
        color_options = set_background(piece, row_idx, index)
        case piece
        when Rook
          print " ♖ ".colorize(color_options)
        when Knight
          print " ♘ ".colorize(color_options)
        when Bishop
          print " ♗ ".colorize(color_options)
        when Queen
          print " ♕ ".colorize(color_options)
        when King
          print " ♔ ".colorize(color_options)
        when Pawn
          print " ♙ ".colorize(color_options)
        else
          print "   ".colorize(color_options)
        end
        if index == 7
          puts
        end
      end
    end

  end

end
