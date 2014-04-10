#!/usr/bin/env ruby
require_relative "./board.rb"

class Game
  attr_accessor :game_board

  def initialize
    self.game_board = Board.new
  end

  def parse_input(user_input)
    letter_to_num = { "A" => 0,
                      "B" => 1,
                      "C" => 2,
                      "D" => 3,
                      "E" => 4,
                      "F" => 5,
                      "G" => 6,
                      "H" => 7
                    }

    move = user_input.split(",")
    move_start_1, move_end_1 = letter_to_num[move[0][0].upcase], letter_to_num[move[1][0].upcase]
    move_start_2, move_end_2 = convert_num(move[0][1].to_i), convert_num(move[1][1].to_i)
    [[move_start_2, move_start_1], [move_end_2, move_end_1]]
  end

  def convert_num(num)
    7 - ((num - 1) % 8)
  end

  def player_piece?(player_move, player)

    if game_board.board[player_move.first][player_move.last].color == :black && player == "Black"
      return true
    elsif game_board.board[player_move.first][player_move.last].color == :white && player == "White"
      return true
    else
      false
    end

  end

  def play

    system "clear"

    puts "WELCOME TO CHESS".rjust(15)
    puts
    puts "GOOD LUCK!".rjust(15)

    player = "Black"
    until self.game_board.game_over? do

      self.game_board.print_board
      puts

      puts "#{player} Player, What is your move?"

      begin
        player_move = parse_input(gets.chomp)

        until self.player_piece?(player_move.first, player) &&
            self.game_board.board[player_move.first.first][player_move.first.last].
            valid_moves.include?(player_move.last) do

          puts "That ain't a valid move!"
          player_move = parse_input(gets.chomp)
        end
        self.game_board.move(player_move.first, player_move.last)
        system("clear")
      rescue InvalidMove
        puts "Invalid move dummy!"
        retry
      rescue
        puts "Enter a better move dummy!"
        retry
      end

      player == "Black" ? player = "White" : player = "Black"

    end

    puts "LOSER! OR WAIT....MAYBE YOU'RE THE WINNER"
  end
end

class InvalidMove < ArgumentError
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end


# awesome_game = Game.new
# awesome_game.play