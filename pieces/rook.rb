require_relative "./sliding_piece.rb"

class Rook <  SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0]]
      color == :white ? @display = "\u2656" : @display = "\u265C"
  end

end