require 'gosu'

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

WIDTH = 400
HEIGHT = 500
SHAPE_DIM = 50

# Instructions:
# Fix the following code so that:
# 1. The shape also can be moved up and down
# 2. the shape does not move out of the window area

class GameWindow < Gosu::Window

  # initialize creates a window with a width an a height
  # and a caption. It also sets up any variables to be used.
  # This is procedure i.e the return value is 'undefined'
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Shape Moving"

    @shape_y = HEIGHT / 2
    @shape_x = WIDTH / 2
  end

  # Put any work you want done in update
  # This is a procedure i.e the return value is 'undefined'
  def update

    if button_down?(Gosu::KbRight) #rightarrow move shape x increment 3
      if @shape_x != (WIDTH - SHAPE_DIM) #width is on the X plane
        @shape_x += 3
      end
    end
    if button_down?(Gosu::KbLeft) && (@shape_x != 0)#leftarrow move shape x decrement 3
        @shape_x -= 3
    end
    if button_down?(Gosu::KbDown) && @shape_y < (HEIGHT - SHAPE_DIM) #height is on the Y plane
      @shape_y += 3 # increament upwards by 3
    end
    if button_down?(Gosu::KbUp) && @shape_y > 0
      @shape_y -= 3 #decrement downwards by 3
    end

  end

  # Draw (or Redraw) the window
  # This is procedure i.e the return value is 'undefined'
  def draw
    Gosu.draw_rect(@shape_x, @shape_y, SHAPE_DIM, SHAPE_DIM, Gosu::Color::RED, ZOrder::TOP, mode=:default)
  end
end

window = GameWindow.new
window.show
