require_relative "./sliding_piece.rb"

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2657" : @display = "\u265D"
  end

end