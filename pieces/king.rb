require_relative "./stepping_piece.rb"

class King < SteppingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2654" : @display = "\u265A"
  end
end