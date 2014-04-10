require_relative "./piece.rb"

class Pawn < Piece

  attr_accessor :deltas, :display, :color, :attack_deltas

  def initialize(pos, board, color)
    super(pos, board, color)
    set_deltas
    color == :white ? @display = "\u2659" : @display = "\u265F"
  end

  def moves
    set_deltas # called multiple times!
    [].tap do |valid_moves|
      self.deltas.each do |each_delta|
        current_position = self.position
        self.initial_position? ? loop_times = 2 : loop_times = 1
        loop_times.times do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          break unless valid?(current_position)
          valid_moves << current_position
        end
      end

      self.attack_deltas.each do |each_delta|
        current_position = self.position
        1.times do
          current_position = (current_position.first + each_delta.first), (current_position.last + each_delta.last)
          break unless piece_to_attack?(current_position)
          valid_moves << current_position
        end
      end
    end
  end

  def on_board?(pos)
    (0..7).cover?(pos.first) && (0..7).cover?(pos.last)
  end

  def valid?(pos)
    if (on_board?(pos) &&
        board[pos.first][pos.last].class == Board::EmptyTile)
      return true
    end
    false
  end

  def initial_position?
    if self.color == :white
      self.position.first == 1
    else
      self.position.first == 6
    end
  end

   def set_deltas
     if self.color == :white
       self.deltas = [[1,0]]
       self.attack_deltas = [[1,-1], [1, 1]]
     else
       self.deltas = [[-1,0]]
       self.attack_deltas = [[-1,-1], [-1, 1]]
     end
   end

  def piece_to_attack?(pos)
    if on_board?(pos)
      unless board[pos.first][pos.last].class == Board::EmptyTile
        return self.color != board[pos.first][pos.last].color
      end
    end
    false
  end

end