class InvalidMove < ArgumentError
end

class Board

  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new([]) * 8 }
    self.generate_board
  end

  class EmptyTile
    attr_accessor :display

    def initialize(pos)
      (pos.first + pos.last).even? ? self.display = "\u2b1c" : self.display = "\u2b1b"
    end

  end

  def generate_board
    self.board.each_index do |row|
      self.board.each_index do |col|
        self.board[row][col] = EmptyTile.new([row,col])
      end
    end
    self.board[0][0] = Rook.new([0, 0], self.board, :white)
    self.board[0][1] = Knight.new([0, 1], self.board, :white)
    self.board[0][2] =  Bishop.new([0, 2], self.board, :white)
    self.board[0][3] =  Queen.new([0, 3], self.board, :white)
    self.board[0][4] =  King.new([0, 4], self.board, :white)
    self.board[0][5] =  Bishop.new([0, 5], self.board, :white)
    self.board[0][6] =  Knight.new([0, 6], self.board, :white)
    self.board[0][7] =  Rook.new([0, 7], self.board, :white)
    self.board[1][0] =  Pawn.new([1, 0], self.board, :white)
    self.board[1][1] =  Pawn.new([1, 1], self.board, :white)
    self.board[1][2] =  Pawn.new([1, 2], self.board, :white)
    self.board[1][3] =  Pawn.new([1, 3], self.board, :white)
    self.board[1][4] =  Pawn.new([1, 4], self.board, :white)
    self.board[1][5] =  Pawn.new([1, 5], self.board, :white)
    self.board[1][6] =  Pawn.new([1, 6], self.board, :white)
    self.board[1][7] =  Pawn.new([1, 7], self.board, :white)
    #
    self.board[7][0] = Rook.new([7, 0], self.board, :black)
    self.board[7][1] = Knight.new([7, 1], self.board, :black)
    self.board[7][2] =  Bishop.new([7, 2], self.board, :black)
    self.board[7][3] =  Queen.new([7, 3], self.board, :black)
    self.board[7][4] =  King.new([7, 4], self.board, :black)
    self.board[7][5] =  Bishop.new([7, 5], self.board, :black)
    self.board[7][6] =  Knight.new([7, 6], self.board, :black)
    self.board[7][7] =  Rook.new([7, 7], self.board, :black)
    self.board[6][0] =  Pawn.new([6, 0], self.board, :black)
    self.board[6][1] =  Pawn.new([6, 1], self.board, :black)
    self.board[6][2] =  Pawn.new([6, 2], self.board, :black)
    self.board[6][3] =  Pawn.new([6, 3], self.board, :black)
    self.board[6][4] =  Pawn.new([6, 4], self.board, :black)
    self.board[6][5] =  Pawn.new([6, 5], self.board, :black)
    self.board[6][6] =  Pawn.new([6, 6], self.board, :black)
    self.board[6][7] =  Pawn.new([6, 7], self.board, :black)
  end

  def move(start_pos, end_pos)
    begin
      piece = self.board[start_pos.first][start_pos.last]
      if piece.valid_moves.include?(end_pos)
        piece.move_piece(end_pos)
        self.board[start_pos.first][start_pos.last] = EmptyTile.new(start_pos)
      end
    rescue
      raise InvalidMove
    end
  end

  def in_check?(color)
    king_position = find_king(color)
    self.board.each_index do |row|
      self.board.each_index do |col|
        current = self.board[row][col]
        unless current.class == EmptyTile || current.color == color
          return true if current.moves.include?(king_position)
        end
      end
    end
    false
  end

  def checkmate?(color)

    return false unless self.in_check?(color)

    self.board.each_index do |row|
      self.board.each_index do |col|
        current = self.board[row][col]
        unless current.class == EmptyTile || current.color != color
          return false unless current.valid_moves.empty?
        end
      end
    end
    true
  end

  def find_king(color)
    self.board.each_index do |row|
      self.board.each_index do |col|
        current = self.board[row][col]
        unless current.class == EmptyTile
          return [row, col] if current.class == King && current.color == color
        end
      end
    end
  end

  def game_over? #not checking for stalemate
    checkmate?(:black) || checkmate?(:white)
  end

  def print_board
    puts
    print "  A B C D E F G H"
    self.board.each_index do |row|
      puts
      print "#{9 - ((row + 1) % 9)} "
      self.board.each_index do |col|
        print "#{self.board[row][col].display} "
      end
      print "#{9 - ((row + 1) % 9)} "
    end
    puts
    print "  A B C D E F G H"
    puts
  end

end

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

    if game_board.board[player_move.first][player_move.last].color == :black && player == 1
      return true
    elsif game_board.board[player_move.first][player_move.last].color == :white && player == 2
      return true
    else
      false
    end

  end

  def play

    system "clear"

    puts "WELCOME TO CHESS"
    puts
    puts "GOOD LUCK!"

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
  end
end

class Piece

  attr_accessor :board, :position, :color
  def initialize(pos, board, color)
    @position = pos
    @board = board
    @color = color
  end

  def moves
    raise NotImplementedAtThisLevel
  end

  def move_piece(new_pos)
    self.board[self.position.first][self.position.last] = Board::EmptyTile.new(self.position)
    self.position = new_pos
    self.board[new_pos.first][new_pos.last] = self
  end

  def move_into_check?(pos)
      dupped_board = self.deep_dup_board

      piece = dupped_board.board[self.position.first][self.position.last]
      piece.move_piece(pos)
      dupped_board.board[self.position.first][self.position.last] = Board::EmptyTile.new(self.position)

      dupped_board.in_check?(self.color)
  end

  def valid_moves

    [].tap do |doable_moves|

      self.moves.each do |move|
        doable_moves << move unless move_into_check?(move)
      end
    end
  end

  def dup_piece(dupped_board_array)
    return self.class.new(self.position, dupped_board_array, self.color)
  end

  def deep_dup_board
    dupped_board_array = Array.new(8) { Array.new([]) * 8 }

    dupped_board_array.each_index do |row|
      dupped_board_array.each_index do |col|
        if self.board[row][col].class == Board::EmptyTile
          dupped_board_array[row][col] = Board::EmptyTile.new([row,col])
        else
          dupped_board_array[row][col] = self.board[row][col].dup_piece(dupped_board_array)
        end
      end
    end

    some_board = Board.new
    some_board.board = dupped_board_array
    some_board

  end
end

class SlidingPiece < Piece

  attr_accessor :deltas, :display

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = []
  end

  def moves
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        loop do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          if attackable?(current_position)
            valid_moves << current_position
            break
          end
          break unless valid?(current_position)
          valid_moves << current_position
        end
      end
    end

  end

  def attackable?(pos)
    if on_board?(pos)
      if self.board[pos.first][pos.last].class != Board::EmptyTile
        return self.board[pos.first][pos.last].color != self.color
      end
    end
    false
  end

  def on_board?(pos)
    (0..7).cover?(pos.first) && (0..7).cover?(pos.last)
  end

  def valid?(pos)
    on_board?(pos) && board[pos.first][pos.last].class == Board::EmptyTile
  end

end


class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2657" : @display = "\u265D"
  end

end

class Rook <  SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0]]
      color == :white ? @display = "\u2656" : @display = "\u265C"
  end

end

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2655" : @display = "\u265B"
  end

end

class SteppingPiece < Piece

  attr_accessor :deltas, :display, :color

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = []
  end

  def moves
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        1.times do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          break unless valid?(current_position)
          valid_moves << current_position
        end
      end
    end
  end

  def valid?(pos)
    if ((0..7).cover?(pos.first) &&
        (0..7).cover?(pos.last)) &&
        ((board[pos.first][pos.last].class == Board::EmptyTile) ||
        (board[pos.first][pos.last].color != self.color))
      return true
    end
    false
  end
end

class Knight < SteppingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[2, 1], [1, 2], [-1, -2], [-2, -1], [-1, 2], [1, -2], [2, -1], [-2, 1]]
    color == :white ? @display = "\u2658" : @display = "\u265E"
  end


end

class King < SteppingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2654" : @display = "\u265A"
  end
end

class Pawn < Piece

  attr_accessor :deltas, :display, :color, :attack_deltas

  def initialize(pos, board, color)
    super(pos, board, color)
    set_deltas
    color == :white ? @display = "\u2659" : @display = "\u265F"
  end

  def moves
    set_deltas # called multiple times!
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        self.initial_position? ? loop_times = 2 : loop_times = 1
        loop_times.times do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          break unless valid?(current_position)
          valid_moves << current_position
        end
      end

      self.attack_deltas.each do |each_delta|
        current_position = self.position
        1.times do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          break unless piece_to_attack?(current_position)
          valid_moves << current_position
        end
      end
    end
  end

  def on_board?(pos)
    (0..7).cover?(pos.first) && (0..7).cover?(pos.last)
  end

  def valid?(pos)
    if (on_board?(pos) &&
        board[pos.first][pos.last].class == Board::EmptyTile)
      return true
    end
    false
  end

  def initial_position?
    if self.color == :white
      self.position.first == 1
    else
      self.position.first == 6
    end
  end

   def set_deltas
     if self.color == :white
       self.deltas = [[1,0]]
       self.attack_deltas = [[1,-1], [1, 1]]
     else
       self.deltas = [[-1,0]]
       self.attack_deltas = [[-1,-1], [-1, 1]]
     end
   end

  def piece_to_attack?(pos)
    if on_board?(pos)
      unless board[pos.first][pos.last].class == Board::EmptyTile
        return self.color != board[pos.first][pos.last].color
      end
    end
    false
  end

end

awesome_game = Game.new
awesome_game.play