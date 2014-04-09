require 'debugger'

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

    1.times do

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

    end #generate pieces

    #self.board[2][4] =  King.new([2, 4], self.board, :black)

    self.print_board

    #self.move([1,],[2,0])
    self.move([1,5],[2,5])
    self.move([2,5],[4,5])

    self.print_board

    p self.in_check?(:white)
    p self.in_check?(:black)

  end

  def move(start_pos, end_pos)
    # if board position (start_pos) contains a piece of your color
    # and piece.moves contains end_pos in the array,
    # it is a move you can make, otherwise exception
    # check if it is an attack or just a move or if piece in the way

    piece = self.board[start_pos.first][start_pos.last]

    if piece.moves.include?(end_pos)
      piece.move_piece(end_pos)
      self.board[start_pos.first][start_pos.last] = EmptyTile.new(start_pos)
      puts 'MOVED'
    else
      puts 'NOT A VALID MOVE!'
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

  def print_board
    puts
    print "  0 1 2 3 4 5 6 7"
    self.board.each_index do |row|
      puts
      print "#{row} "
      self.board.each_index do |col|
        print "#{self.board[row][col].display} "
      end
      print "#{row} "
    end
    puts
    print "  A B C D E F G H"
    puts
    puts
  end

end

class Game
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
    self.board[self.position.first][self.position.last] = nil
    self.position = new_pos
    self.board[new_pos.first][new_pos.last] = self
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

  # def initialize(pos, board, color)
  #   super(pos, board, color)
  #   color == :white ? @display = "\u2659" : @display = "\u265F"
  # end
  #
  # def moves
  # end

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
      p valid_moves
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

  #check color
  #is it on row 6 or row 1 / or check flag
  #is there enemy piece diaganal to it?

  #made first move?
  #which direction can it go?
  #can it attack?


end

game_board = Board.new
# game_board.print_board
# john_paul = Bishop.new([0, 0], game_board, :black)
# p john_paul.moves