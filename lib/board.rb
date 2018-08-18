require_relative 'piece'

GameView = Struct.new(:blocks, :current_piece_blocks, :is_game_over)

class Board
  def initialize(width, height)
    @is_game_over = false
    @width  = width
    @height = height
    @drop_pos = Position.new(width / 2, height - 2)
    @random = Random.new
    @current_piece = spawn_new_piece
    @blocks = [] + @current_piece.blocks
  end

  def view
    GameView.new(@blocks, @current_piece.blocks, @is_game_over)
  end

  def spawn_new_piece
    kind = @random.rand(0 .. PieceKind.constants.size - 1)
    Piece.new(@drop_pos, kind)
  end

  def move_left
    move_by(-1, 0)
  end

  def move_right
    move_by(1, 0)
  end

  def move_down
    if !move_by(0, -1)
      clear_full_rows
      check_game_over
      if !@is_game_over
        @current_piece = spawn_new_piece
        @prev_piece = @current_piece
      end
    end
  end

  def move_by(delta_x, delta_y)
    transit do
      @current_piece.move_by(delta_x, delta_y)
    end
  end

  def rotate_cw
    transit do
      @current_piece.rotate_by(-Math::PI / 2)
    end
  end

  def transit(&block)
    unloaded = unload(@current_piece, @blocks)
    moved = yield
    validate(moved, unloaded) do
      @blocks = load(moved, unloaded)
      @current_piece = moved
    end
  end

  def unload(piece, blocks)
    poss = piece.blocks.map { |local| local.pos }
    blocks.reject { |block| poss.include?(block.pos) }
  end

  def load(piece, blocks)
    blocks + piece.blocks
  end

  def validate(piece, fixed, &block)
    result = not_collide?(piece, fixed)
    if result
      yield
    end
    result
  end

  def not_collide?(piece, fixed)
    piece.blocks.all? do |local|
      in_bounds?(local.pos.x, local.pos.y) &&
      !collide_fixed_blocks?(fixed, local.pos)
    end
  end

  def in_bounds?(x, y)
    0 <= x && x < @width && 0 <= y && y < @height
  end

  def collide_fixed_blocks?(fixed, pos)
    fixed.any? { |b| pos == b.pos }
  end

  def clear_full_rows
    filled_row = Array.new(@height, 0)
    compact_size = Array.new(@height, 0)
    @blocks.each { |b| filled_row[b.pos.y] = filled_row[b.pos.y] + 1 }
    @blocks = @blocks.reject { |b| filled_row[b.pos.y] >= @width }

    (0 .. @height - 1).each do |r|
      if filled_row[r] >= @width
        (r + 1 .. @height - 1).each do |y|
          compact_size[y] = compact_size[y] + 1
        end
      end
    end

    @blocks = @blocks.map do |b|
      Block.new(Position.new(b.pos.x, b.pos.y - compact_size[b.pos.y]), b.kind)
    end
  end

  def check_game_over
    if @prev_piece
      @is_game_over = @prev_piece.blocks == @current_piece.blocks
    end
  end
end
