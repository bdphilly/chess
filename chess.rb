class Board

  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new([]) * 8 }
    self.generate_board
  end

  def generate_board
    self.board.each_index do |row|
      self.board.each_index do |col|
        self.board[row][col] = "nil"
      end
    end

    john_paul = Queen.new([4, 4], self.board)
    self.board[4][4] = john_paul

    john_paul.moves.each do |position|
      self.board[position.first][position.last] = john_paul
    end

  end

  def print_board
    self.board.each_index do |row|
      puts
      self.board.each_index do |col|
        print "#{self.board[row][col].display} "
      end
    end
    puts

  end

end

class Game
end

class Piece
  attr_accessor :board, :position
  def initialize(pos, board)
    @position = pos
    @board = board
  end

  def moves

    #return array
  end

end

class SlidingPiece < Piece

  def initialize(pos, board)
    super(pos, board)
  end


  def moves
    possible_moves = []
    one_space_moves = [[1, 0], [0, 1], [0, -1], [-1, 0]]
    # self.pos
    one_space_moves.each do |deltas|
      possible_moves << helper_move(deltas)
    end

    possible_moves.flatten(1)
  end

  def helper_move(deltas)
    current_position = self.position

    delta_move = []

    2.times do
    # while valid?
      current_position = (current_position.first + deltas.first), (current_position.last + deltas.last)
      delta_move << current_position
    end
    delta_move

  end

  def valid?
    true
  end

end


class Bishop < SlidingPiece

  attr_accessor :display

  def initialize(pos, board)
    super(pos, board)
    @display = ' B '
  end


  def moves
    possible_moves = []
    one_space_moves = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    # self.pos
    one_space_moves.each do |deltas|
      possible_moves << helper_move(deltas)
    end

    possible_moves.flatten(1)
  end

  def helper_move(deltas)
    current_position = self.position

    delta_move = []

    2.times do
    # while valid?
      current_position = (current_position.first + deltas.first), (current_position.last + deltas.last)
      delta_move << current_position
    end
    delta_move

  end

  def valid?
    true
  end

end

class Rook <  SlidingPiece

  attr_accessor :display

  def initialize(pos, board)
    super(pos, board)
    @display = ' R '
  end


  def moves
    possible_moves = []
    one_space_moves = [[1, 0], [0, 1], [0, -1], [-1, 0]]
    # self.pos
    one_space_moves.each do |deltas|
      possible_moves << helper_move(deltas)
    end

    possible_moves.flatten(1)
  end

  def helper_move(deltas)
    current_position = self.position

    delta_move = []

    2.times do
    # while valid?
      current_position = (current_position.first + deltas.first), (current_position.last + deltas.last)
      delta_move << current_position
    end
    delta_move

  end

  def valid?
    true
  end

end

class Queen < SlidingPiece

  attr_accessor :display

  def initialize(pos, board)
    super(pos, board)
    @display = ' Q '
  end


  def moves
    possible_moves = []
    one_space_moves = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    # self.pos
    one_space_moves.each do |deltas|
      possible_moves << helper_move(deltas)
    end

    possible_moves.flatten(1)
  end

  def helper_move(deltas)
    current_position = self.position

    delta_move = []

    2.times do
    # while valid?
      current_position = (current_position.first + deltas.first), (current_position.last + deltas.last)
      delta_move << current_position
    end
    delta_move

  end

  def valid?
    true
  end

end

class SteppingPiece < Piece

  def initialize(pos, board)
    super(pos, board)
  end

  def moves
  end

end

class Pawn < Piece

  def initialize(pos, board)
    super(pos, board)
  end

  def moves
  end

end

game_board = Board.new
game_board.print_board
john_paul = Bishop.new([4, 4], game_board)
p john_paul.moves