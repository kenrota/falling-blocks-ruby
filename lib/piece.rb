module PieceKind
  B = 0
  I = 1
  L = 2
  O = 3
  S = 4
end

Position = Struct.new(:x, :y)

Block = Struct.new(:pos, :kind)

class Piece
  attr_accessor :pos, :locals

  LOCAL_POS = {
    PieceKind::B => [Position.new(0, 0), Position.new(0, 1)],
    PieceKind::I => [Position.new(-1, 0), Position.new(0, 0), Position.new(1, 0)],
    PieceKind::L => [Position.new(0, 0), Position.new(1, 0), Position.new(0, 1)],
    PieceKind::O => [Position.new(1, 0)],
    PieceKind::S => [Position.new(0, 0), Position.new(1, 1)],
  }

  def initialize(start_pos, kind)
    @pos = start_pos
    @kind = kind
    @locals = LOCAL_POS[kind]
  end

  def blocks
    @locals.map do |local|
      Block.new(Position.new(local.x + pos.x, local.y + pos.y), @kind)
    end
  end

  def move_by(delta_x, delta_y)
    next_pos = Position.new(pos.x + delta_x, pos.y + delta_y)
    new_piece = self.clone
    new_piece.pos = next_pos
    new_piece
  end

  def rotate_by(theta)
    sin = Math.sin(theta)
    cos = Math.cos(theta)
    new_piece = self.clone
    new_piece.locals = locals.map do |local|
      new_x = (local.x * cos - local.y * sin).round
      new_y = (local.x * sin + local.y * cos).round
      Position.new(new_x, new_y)
    end
    new_piece
  end
end
