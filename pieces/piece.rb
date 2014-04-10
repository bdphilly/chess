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