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

    john_paul = King.new([4, 4], self.board)
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

  attr_accessor :deltas, :display

  def initialize(pos, board)
    super(pos, board)
    @deltas = []
  end

  def moves
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        2.times do  # REPLACE with valid? #
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          valid_moves << current_position
        end
      end
    end
  end

  def valid?
    true
  end

end

class Bishop < SlidingPiece

  def initialize(pos, board)
    super(pos, board)
    @deltas = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
  @display = " \u265D "
  end

end

class Rook <  SlidingPiece


  def initialize(pos, board)
    super(pos, board)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0]]
      @display = " \u265C "
  end

end

class Queen < SlidingPiece

  def initialize(pos, board)
    super(pos, board)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    @display = " \u265B "
  end

end

class SteppingPiece < Piece

  attr_accessor :deltas, :display

  def initialize(pos, board)
    super(pos, board)
    @deltas = []
  end

  def moves
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        1.times do  # REPLACE with valid? #
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          valid_moves << current_position
        end
      end
    end
  end

  def valid?
    true
  end





end

class Knight < SteppingPiece

  def initialize(pos, board)
    super(pos, board)
    @deltas = [[2, 1], [1, 2], [-1, -2], [-2, -1], [-1, 2], [1, -2], [2, -1], [-2, 1]]
    @display = " \u265E "
  end


end

class King < SteppingPiece

  def initialize(pos, board)
    super(pos, board)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    @display = " \u265A "
  end


end







class Pawn < Piece

  def initialize(pos, board)
    super(pos, board)
    @display = " \u265F "
  end

  def moves
  end

end

game_board = Board.new
game_board.print_board
john_paul = Bishop.new([4, 4], game_board)
p john_paul.moves