require_relative 'piece'
require_relative 'display'
require_relative 'board'
require_relative 'player'
require 'colorize'
require 'byebug'


class Game

  def initialize(player1, player2)
    @board = Board.new
    @player1 = Player.new(player1, "red")
    @player2 = Player.new(player2, "white")
    @current_player = @player1
  end

  def swap_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def play
    @board.set_board
    @board.print_board
    until @board.checkmate?("red") || @board.checkmate?("white")
      if @board.in_check?("red")
        puts "Red is in check."
        sleep(2)
      elsif @board.in_check?("white")
        puts "White is in check."
        sleep(2)
      end
      play_turn
    end
    puts "Checkmate!"
  end

  def play_turn
    puts "It's #{@current_player.name}'s move."
    sleep(2)
    begin
      @board.move
    rescue ChessError => e
      puts e.message
      sleep(2)
      retry
    ensure
      system("clear")
      @board.print_board
      swap_player
    end
  end

end



if __FILE__ == $PROGRAM_NAME
  game = Game.new("Julia", "Gigi")
  game.play
end
