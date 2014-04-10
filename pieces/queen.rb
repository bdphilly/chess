require_relative "./sliding_piece.rb"

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @deltas = [[1, 0], [0, 1], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    color == :white ? @display = "\u2655" : @display = "\u265B"
  end

end