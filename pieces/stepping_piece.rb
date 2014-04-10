require_relative "./piece.rb"

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
