require 'rubygems'
require 'gosu'

# Instructions:  This code also needs to be fixed and finished!
# As in the earlier button tasks the "Click Me" text is not appearing
# on the button, also both the mouse_x and mouse_ co-ordinate should
# be shown, regardless of whether the mouse has been clicked or not.
# The button should be highlighted when the mouse moves over it
# (i.e it should have a black border around the outside)
# finally, a user has noticed that in this version also sometimes the
# button action occurs when you click outside the button area and vice-versa.


# FOR THE CREDIT VERSION:
# display a colored border that 'highlights' the button when the mouse moves over it

# determines whether a graphical widget is placed over others or not
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Global constants
WIN_WIDTH = 640
WIN_HEIGHT = 400

class DemoWindow < Gosu::Window

  # set up variables and attributes
  def initialize()
    super(WIN_WIDTH, WIN_HEIGHT, false)
    @background = Gosu::Color::WHITE #set default white
    @button_font = Gosu::Font.new(20) #font size 20
    @info_font = Gosu::Font.new(10) #font size 10
    @locs = [60,60] #to lock a word on this specify coordinates
  end


  # Draw the background, the button with 'click me' text and text
  # showing the mouse coordinates
  def draw()
    # Draw background color
    Gosu.draw_rect(0, 0, WIN_WIDTH, WIN_HEIGHT, @background, ZOrder::BACKGROUND, mode=:default) #white background called by initializing
    # Draw the rectangle that provides the background.
    if mouse_over_button(mouse_x, mouse_y) #calling the varible below if true then display as below
      Gosu.draw_rect(48, 48, 104, 54, Gosu::Color::BLACK, ZOrder::MIDDLE, mode=:default) # Black border
    end
    # ????
    # Draw the button
    Gosu.draw_rect(50, 50, 100, 50, Gosu::Color::GREEN, ZOrder::TOP, mode=:default) #normal green box
    # Draw the button text
    @button_font.draw_text("Click me", @locs[0], @locs[1], ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK) #text "click me"
    #locs global varible set on certain specify coords
    # Draw the mouse_x position
    @info_font.draw_text("mouse_x: #{mouse_x}", 0, 350, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK) #X position
    @info_font.draw_text("mouse_y: #{mouse_y}", 100, WIN_HEIGHT - 50, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK) #Y position
    # Draw the mouse_y position
    # @info_font.draw("mouse_y: #{mouse_y}", ......... )
  end

  # this is called by Gosu to see if it should show the cursor (or mouse)
  def needs_cursor?; true; end

 # This still needs to be fixed!

  def mouse_over_button(mouse_x, mouse_y)
    if ((mouse_x > 50 and mouse_x < 150) and (mouse_y > 50 and mouse_y < 100))
      #if cursor is more than 50 and less than 150 on X coords
      #if cursor is more than 50 and less than 100 on Y coords
      true #then display true so enable hover effect
    else
      false #if not then false so nothing will display
    end
  end

  # If the button area (rectangle) has been clicked on change the background color
  # also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
  # you will learn about inheritance in the OOP unit - for now just accept that
  # these are available and filled with the latest x and y locations of the mouse click.
  def button_down(id)
    case id
    when Gosu::MsLeft #when left clicked on mouse
      if mouse_over_button(mouse_x, mouse_y) #if its click on certain coord set in the function above
        @background = Gosu::Color::YELLOW #change background yellow
      else
        @background = Gosu::Color::WHITE #white background if not
      end
    end
  end
end

# Lets get started!
DemoWindow.new.show()
