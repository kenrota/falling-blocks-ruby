require 'Qt'
require_relative '../lib/ui'

class QtApp < Qt::Widget
  DARK_RED     = Qt::Color.new(128, 0,   0,   255)
  DARK_BLUE    = Qt::Color.new(0,   0,   128, 255)
  DARK_GREEN   = Qt::Color.new(0,   128, 0,   255)
  DARK_YELLOW  = Qt::Color.new(128, 128, 0,   255)
  DARK_MAGENTA = Qt::Color.new(128, 0,   128, 255)
  GRAY         = Qt::Color.new(128, 128, 128, 255)
  LIGHT_GRAY   = Qt::Color.new(192, 192, 192, 255)

  PIECE_COLOR_MAPPING = {
    PieceKind::I => DARK_RED,
    PieceKind::L => DARK_BLUE,
    PieceKind::O => DARK_GREEN,
    PieceKind::B => DARK_YELLOW,
    PieceKind::S => DARK_MAGENTA
  }

  BOARD_WIDTH   = 10
  BOARD_HEIGHT  = 10
  BLOCK_SIZE    = 15
  WINDOW_WIDTH  = BOARD_WIDTH  * BLOCK_SIZE + 1
  WINDOW_HEIGHT = BOARD_HEIGHT * BLOCK_SIZE + 1

  def initialize
    super

    @ui = UI.new(BOARD_WIDTH, BOARD_HEIGHT)

    setGeometry(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

    @timer = Qt::BasicTimer.new
    @timer.start(1000, self)

    show
  end

  def keyPressEvent(event)
    if !@ui.view.is_game_over
      case event.key
      when Qt::Key_Left  then @ui.left
      when Qt::Key_Right then @ui.right
      when Qt::Key_Up    then @ui.up
      when Qt::Key_Down  then @ui.down
      else
        super(event)
      end
      update
    end
  end

  def paintEvent(_event)
    painter = Qt::Painter.new(self)
    draw_grid(painter)
    draw_blocks(painter, @ui.view.blocks)
    draw_blocks(painter, @ui.view.current_piece_blocks)
    painter.end
  end

  def timerEvent(_event)
    if @ui.view.is_game_over
      @timer.stop
    else
      @ui.down
      repaint
    end
  end

  def draw_rect(painter, x, y)
    painter.drawRect(
      x * BLOCK_SIZE, (BOARD_HEIGHT - y - 1) * BLOCK_SIZE,
      BLOCK_SIZE, BLOCK_SIZE
    )
  end

  def draw_grid(painter)
    painter.setPen(GRAY)
    painter.setBrush(Qt::Brush.new(LIGHT_GRAY))

    BOARD_WIDTH.times do |x|
      BOARD_HEIGHT.times do |y|
        draw_rect(painter, x, y)
      end
    end
  end

  def draw_blocks(painter, blocks)
    painter.setPen(GRAY)
    blocks.each do |block|
      color = @ui.view.is_game_over ? GRAY : PIECE_COLOR_MAPPING[block.kind]
      painter.setBrush(Qt::Brush.new(color))
      draw_rect(painter, block.pos.x, block.pos.y)
    end
  end
end

app = Qt::Application.new(ARGV)
QtApp.new
app.exec
