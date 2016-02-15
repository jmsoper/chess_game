require 'byebug'
class Display

  def initialize(board)
    @board = board
    @cursor = @board[0,0]
  end

  def show_board
    puts "  A  B  C  D  E  F  G  H"
    @board.grid.each_with_index do |row, row_idx|
      print row_idx
      row.each_with_index do |piece, index|
        #  debugger
        case piece
        when Rook
          print " ♖ ".colorize(piece.color.to_sym)
        when Knight
          print " ♘ ".colorize(piece.color.to_sym)
        when Bishop
          print " ♗ ".colorize(piece.color.to_sym)
        when Queen
          print " ♕ ".colorize(piece.color.to_sym)
        when King
          print " ♔ ".colorize(piece.color.to_sym)
        when Pawn
          print " ♙ ".colorize(piece.color.to_sym)
        else
          print " ∙ "
        end
        if index == 7
          puts
        end
      end
    end

  end

end
