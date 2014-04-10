require_relative "./pieces.rb"

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

    (0..7).each do |i|
      self.board[1][i] =  Pawn.new([1, i], self.board, :white)
      self.board[6][i] =  Pawn.new([6, i], self.board, :black)
    end

    self.board[7][0] = Rook.new([7, 0], self.board, :black)
    self.board[7][1] = Knight.new([7, 1], self.board, :black)
    self.board[7][2] =  Bishop.new([7, 2], self.board, :black)
    self.board[7][3] =  Queen.new([7, 3], self.board, :black)
    self.board[7][4] =  King.new([7, 4], self.board, :black)
    self.board[7][5] =  Bishop.new([7, 5], self.board, :black)
    self.board[7][6] =  Knight.new([7, 6], self.board, :black)
    self.board[7][7] =  Rook.new([7, 7], self.board, :black)

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