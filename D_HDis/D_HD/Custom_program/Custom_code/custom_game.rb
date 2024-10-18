require 'gosu'

# Class for entering the warrior name
class WarriorName
  def initialize(window) # Initialize the WarriorName state with the game window
    @window = window
    @font = Gosu::Font.new(30) # Font size 30 for text
    @input = "" # Text input starts empty
    @enter_button = Gosu::Image.from_text("ENTER", 30) # Button to enter the name
    @screen_width = 1000
    @screen_height = 800
  end

  def update
    @input = @window.text_input.text if @window.text_input # Update input text
  end

  def draw
    @window.draw_background # Draw background

    text_prompt = "PLEASE ENTER HUNTER NAME:"
    text_prompt_width = @font.text_width(text_prompt) # Calculate text width for centering
    input_text_width = @font.text_width(@input)
    enter_button_width = @enter_button.width

    # Draw text prompt, input text, and enter button
    @font.draw_text(text_prompt, (@screen_width - text_prompt_width) / 2, 150, 1)
    @font.draw_text(@input, (@screen_width - input_text_width) / 2, 200, 1)
    @enter_button.draw((@screen_width - enter_button_width) / 2, 300, 1)
  end

  def button_down(id) # Handle button press
    if id == Gosu::MsLeft # Check if left mouse button is clicked
      mouse_x = @window.mouse_x
      mouse_y = @window.mouse_y

      # Check if enter button is clicked
      if button_hover?(mouse_x, mouse_y, (@screen_width - @enter_button.width) / 2, 300, @enter_button)
        @window.hunter_name = @input # Set hunter name
        @window.show_menu # Switch to menu screen
      end
    end
  end

  private

  # Check if mouse is hovering over a button
  def button_hover?(mouse_x, mouse_y, button_x, button_y, button_image)
    mouse_x >= button_x && mouse_x <= button_x + button_image.width &&
    mouse_y >= button_y && mouse_y <= button_y + button_image.height
  end
end

# Class for the main menu
class Menu
  def initialize(window) # Initialize the menu state with the game window
    @window = window
    @font = Gosu::Font.new(30) # Font size 30 for text
    @start_button = Gosu::Image.from_text("START", 30) # Button to start the game
    @screen_width = 1000
  end

  def draw
    @window.draw_background # Draw background

    welcome_text = "WELCOME HUNTER #{@window.hunter_name}" # Welcome message with hunter name
    welcome_text_width = @font.text_width(welcome_text) # Calculate text width for centering
    start_button_width = @start_button.width

    # Draw welcome text and start button
    @font.draw_text(welcome_text, (@screen_width - welcome_text_width) / 2, 150, 1)
    @start_button.draw((@screen_width - start_button_width) / 2, 300, 1)
  end

  def button_down(id) # Handle button press
    if id == Gosu::MsLeft # Check if left mouse button is clicked
      mouse_x = @window.mouse_x
      mouse_y = @window.mouse_y

      # Check if start button is clicked
      if button_hover?(mouse_x, mouse_y, (@screen_width - @start_button.width) / 2, 300, @start_button)
        @window.start_game # Start the game
      end
    end
  end

  private

  # Check if mouse is hovering over a button
  def button_hover?(mouse_x, mouse_y, button_x, button_y, button_image)
    mouse_x >= button_x && mouse_x <= button_x + button_image.width &&
    mouse_y >= button_y && mouse_y <= button_y + button_image.height
  end
end

# Class for the options menu
class Options
  def initialize(window) # Initialize the options state with the game window
    @window = window
    @font = Gosu::Font.new(30) # Font size 30 for text
    @resume_button = Gosu::Image.from_text("Resume", 30) # Button to resume the game
    @restart_button = Gosu::Image.from_text("Restart", 30) # Button to restart the game
    @back_button = Gosu::Image.from_text("Back to Menu", 30) # Button to go back to the main menu
    @screen_width = 1000
  end

  def draw
    @window.draw_background # Draw background

    options_text = "Options" # Options text
    options_text_width = @font.text_width(options_text) # Calculate text width for centering
    resume_button_width = @resume_button.width
    restart_button_width = @restart_button.width
    back_button_width = @back_button.width

    # Draw options text and buttons
    @font.draw_text(options_text, (@screen_width - options_text_width) / 2, 150, 1)
    @resume_button.draw((@screen_width - resume_button_width) / 2, 250, 1)
    @restart_button.draw((@screen_width - restart_button_width) / 2, 300, 1)
    @back_button.draw((@screen_width - back_button_width) / 2, 350, 1)
  end

  def button_down(id) # Handle button press
    if id == Gosu::MsLeft # Check if left mouse button is clicked
      mouse_x = @window.mouse_x
      mouse_y = @window.mouse_y

      # Check if buttons are clicked and handle accordingly
      if button_hover?(mouse_x, mouse_y, (@screen_width - @resume_button.width) / 2, 250, @resume_button)
        @window.resume_game # Resume the game
      elsif button_hover?(mouse_x, mouse_y, (@screen_width - @restart_button.width) / 2, 300, @restart_button)
        @window.restart_game # Restart the game
      elsif button_hover?(mouse_x, mouse_y, (@screen_width - @back_button.width) / 2, 350, @back_button)
        @window.show_menu # Go back to the main menu
      end
    end
  end

  private

  # Check if mouse is hovering over a button
  def button_hover?(mouse_x, mouse_y, button_x, button_y, button_image)
    mouse_x >= button_x && mouse_x <= button_x + button_image.width &&
    mouse_y >= button_y && mouse_y <= button_y + button_image.height
  end
end

# Class for the main game
class Game
  attr_reader :score, :start_time # Allow access to score and start time

  def initialize(window) # Initialize the game state with the game window
    @window = window
    @avatar_image = Gosu::Image.new("media/vampierhunter_avatar.png", tileable: true) # Avatar image
    @avatar_x = 50 # Initial position of the avatar
    @avatar_y = 250
    @bullets = [] # Array to store bullets
    @entities = [] # Array to store entities
    @score = 0 # Initial score
    @time_limit = 60_000 # 2 minutes time limit in milliseconds
    @start_time = Gosu.milliseconds # Start time of the game
    @font = Gosu::Font.new(20) # Font size 20 for text
    @shooting = false # Shooting state
    spawn_entity # Spawn an initial entity
  end

  def update
    # Movement controls for the avatar
    if Gosu.button_down? Gosu::KB_W
      @avatar_y -= 5 if @avatar_y > 0
    end
    if Gosu.button_down? Gosu::KB_S
      @avatar_y += 5 if @avatar_y < @window.height - 50
    end
    if Gosu.button_down? Gosu::KB_A
      @avatar_x -= 5 if @avatar_x > 0
    end
    if Gosu.button_down? Gosu::KB_D
      @avatar_x += 5 if @avatar_x < @window.width - 50
    end

    @bullets.each(&:update) # Update all bullets
    @entities.each(&:update) # Update all entities
    @bullets.reject! { |bullet| bullet.out_of_bounds? } # Remove out-of-bounds bullets
    @entities.reject! do |entity| # Remove entities hit by bullets
      if entity.hit_by?(@bullets)
        @score += 100 # Increase score
        true
      else
        false
      end
    end
    spawn_entity if rand < 0.01 # Randomly spawn a new entity

    elapsed_time = Gosu.milliseconds - @start_time # Calculate elapsed time
    if elapsed_time >= @time_limit # Check if time limit is reached
      @window.show_menu # Go back to the menu
    end
  end

  def draw
    @window.draw_background # Draw background

    elapsed_time = Gosu.milliseconds - @start_time # Calculate elapsed time
    remaining_time = [@time_limit - elapsed_time, 0].max / 1000 # Calculate remaining time in seconds

    # Draw avatar, bullets, entities, score, and remaining time
    @avatar_image.draw(@avatar_x, @avatar_y, 1)
    @bullets.each(&:draw)
    @entities.each(&:draw)
    @font.draw_text("Score: #{@score}", 10, 10, 1)
    @font.draw_text("Time: #{remaining_time}", 10, 30, 1)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      @window.show_options # Show options menu
    elsif id == Gosu::MsLeft # Check if left mouse button is clicked
      unless @shooting
        mouse_x = @window.mouse_x
        mouse_y = @window.mouse_y
        direction_x = mouse_x - @avatar_x
        direction_y = mouse_y - @avatar_y
        @bullets << Bullet.new(@avatar_x + 25, @avatar_y + 25, direction_x, direction_y) # Create a new bullet
        @shooting = true # Set shooting state
      end
    end
  end

  def button_up(id)
    @shooting = false if id == Gosu::MsLeft # Reset shooting state when mouse button is released
  end

  private

  def spawn_entity
    @entities << Entity.new(rand(@window.width - 50), rand(@window.height - 50)) # Spawn a new entity at a random position
  end
end

# Class for bullets
class Bullet
  SPEED = 5 # Speed of bullets
  @@image = Gosu::Image.new("media/bullet.png") # Load the bullet image

  def initialize(x, y, direction_x, direction_y)
    @x = x
    @y = y
    magnitude = Math.sqrt(direction_x**2 + direction_y**2)
    @direction_x = SPEED * direction_x / magnitude # Calculate x direction
    @direction_y = SPEED * direction_y / magnitude # Calculate y direction
  end

  def update
    @x += @direction_x # Update bullet position
    @y += @direction_y
  end

  def draw
    @@image.draw(@x, @y, 1) # Draw the bullet image
  end

  def out_of_bounds?
    @x < 0 || @x > 1000 || @y < 0 || @y > 800 # Check if the bullet is out of bounds
  end

  def hit?(entity)
    Gosu.distance(@x, @y, entity.x, entity.y) < 25 # Check if the bullet hits an entity
  end
end

# Class for entities (enemies)
class Entity
  SPEED = 2 # Speed of entities

  attr_reader :x, :y # Allow access to x and y coordinates

  def initialize(x, y) # Initialize the entity with a position
    @x = x
    @y = y
    @direction = rand(360) # Random initial direction
    @entity_image = Gosu::Image.new("media/batentity.png", tileable: true) # Load the entity image
  end

  def update
    @x += SPEED * Gosu.offset_x(@direction, 1) # Update entity position
    @y += SPEED * Gosu.offset_y(@direction, 1)
    @direction += rand(-2..2) # Randomly change direction
    @direction %= 360
  end

  def draw
    @entity_image.draw(@x, @y, 1) # Draw the entity image
  end

  def hit_by?(bullets)
    bullets.any? { |bullet| bullet.hit?(self) } # Check if the entity is hit by any bullet
  end
end

# Main game window class
class GameWindow < Gosu::Window
  attr_accessor :hunter_name # Allow access to hunter name

  def initialize
    super(1000, 800, false) # Set window size and disable fullscreen
    self.caption = "Shoot the Dracula" # Set window caption
    @hunter_name = "" # Initialize hunter name
    @state = :enter_name # Initial state is to enter name
    @warrior_name_state = WarriorName.new(self) # Create warrior name state
    @menu_state = Menu.new(self) # Create menu state
    @game_state = nil # Game state will be initialized later
    @options_state = Options.new(self) # Create options state
    @background_image = Gosu::Image.new("media/pixelbg.png", tileable: true) # Load background image
    self.text_input = Gosu::TextInput.new # Enable text input
  end

  def update
    case @state # Update based on current state
    when :enter_name
      @warrior_name_state.update
    when :menu
      # No updates required for menu
    when :game
      @game_state.update
    when :options
      # No updates required for options
    end
  end

  def draw
    case @state # Draw based on current state
    when :enter_name
      @warrior_name_state.draw
    when :menu
      @menu_state.draw
    when :game
      @game_state.draw
    when :options
      @options_state.draw
    end
  end

  def button_down(id)
    case @state # Handle button press based on current state
    when :enter_name
      @warrior_name_state.button_down(id)
    when :menu
      @menu_state.button_down(id)
    when :game
      @game_state.button_down(id)
      if id == Gosu::KbEscape
        @state = :options # Show options menu if escape key is pressed
      end
    when :options
      @options_state.button_down(id)
    end
  end

  def button_up(id)
    @game_state.button_up(id) if @state == :game # Handle button release in game state
  end

  def draw_background
    @background_image.draw(0, 0, 0) # Draw background image
  end

  def show_menu
    @state = :menu # Switch to menu state
    self.text_input = nil # Disable text input
  end

  def start_game
    @game_state = Game.new(self) # Initialize game state
    @state = :game # Switch to game state
  end

  def show_options
    @state = :options # Switch to options state
  end

  def restart_game
    @game_state = Game.new(self) # Restart the game
    @state = :game # Switch to game state
  end

  def resume_game
    @state = :game # Resume the game
  end
end

window = GameWindow.new
window.show # Show the game window
