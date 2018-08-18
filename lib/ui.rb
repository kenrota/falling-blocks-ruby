require_relative 'board'

class UI
  def initialize(board_width, board_height)
    @board = Board.new(board_width, board_height)
  end

  def left
    @board.move_left
  end

  def right
    @board.move_right
  end

  def up
    @board.rotate_cw
  end

  def down
    @board.move_down
  end

  def view
    @board.view
  end
end
