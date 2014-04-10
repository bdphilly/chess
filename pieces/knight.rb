require_relative "stepping_piece.rb"

class Knight < SteppingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[2, 1], [1, 2], [-1, -2], [-2, -1], [-1, 2], [1, -2], [2, -1], [-2, 1]]
    color == :white ? @display = "\u2658" : @display = "\u265E"
  end

end