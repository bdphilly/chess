require_relative "./piece.rb"

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
