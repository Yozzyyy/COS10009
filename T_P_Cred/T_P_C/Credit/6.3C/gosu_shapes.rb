require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(640, 400, false)
    self.caption = "Skeleton"
  end

  def draw
    draw_quad(0, 0, 0xff_808080, 640, 0, 0xff_808080, 0, 400, 0xff_808080, 640, 400, 0xff_808080, ZOrder::BACKGROUND)
    draw_quad(64, 200, 0xff_708090, 224, 200, 0xff_708090, 64,250, 0xff_708090, 224, 250, 0xff_708090, ZOrder::MIDDLE)
    draw_quad(416,200, 0xff_708090, 576, 200, 0xff_708090, 416,250, 0xff_708090, 576, 250, 0xff_708090, ZOrder::MIDDLE)
    draw_quad(224,250, 0xff_71797E, 416, 250, 0xff_71797E, 224,300, 0xff_71797E, 416, 300, 0xff_71797E, ZOrder::MIDDLE)
    draw_quad(64,300, 0xff_708090, 576, 300, 0xff_708090, 64,350, 0xff_708090, 576, 350, 0xff_708090, ZOrder::MIDDLE)
    draw_triangle(448, 300, 0xff_36454F, 512, 300, 0xff_36454F, 480, 350, 0xff_36454F, ZOrder::TOP, mode=:default)


    img2 = Gosu::Image.new(Circle.new(17))
    img2.draw(150, 200, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
    img2.draw(500, 200, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)

    img3 = Gosu::Image.new(Circle.new(10))
    img3.draw(163, 215, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    img3.draw(513, 215, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)


  end
end

DemoWindow.new.show

