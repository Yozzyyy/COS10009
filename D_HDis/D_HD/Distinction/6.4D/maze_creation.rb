require 'gosu'

# Module defining drawing order constants
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Constants for map dimensions and cell size
MAP_WIDTH = 200
MAP_HEIGHT = 200
CELL_DIM = 20

# Class representing a single cell in the grid
class Cell
  # Attributes for cell connections, state, and path information
  attr_accessor :north, :south, :east, :west, :vacant, :visited, :on_path

  # Constructor to initialize cell attributes
  def initialize()
    @north = nil     # Pointer to the cell to the north
    @south = nil     # Pointer to the cell to the south
    @east = nil      # Pointer to the cell to the east
    @west = nil      # Pointer to the cell to the west
    @vacant = false  # Flag indicating if the cell is vacant (true) or a wall (false)
    @visited = false # Flag indicating if the cell has been visited during pathfinding
    @on_path = false # Flag indicating if the cell is part of the current path
  end
end

# Main game window class inheriting from Gosu::Window
class GameWindow < Gosu::Window

  # Constructor to initialize the game window and grid
  def initialize
    super MAP_WIDTH, MAP_HEIGHT, false   # Initialize the Gosu window with dimensions and not fullscreen
    self.caption = "Map Creation"        # Set window title
    @path = nil                          # Variable to store the found path

    x_cell_count = MAP_WIDTH / CELL_DIM   # Calculate number of cells in the x-direction
    y_cell_count = MAP_HEIGHT / CELL_DIM  # Calculate number of cells in the y-direction

    @columns = Array.new(x_cell_count)    # Array to hold columns of cells
    column_index = 0                      # Initialize column index

    # Create cells for each position in the grid       row= y-grid column= x-grid
    while (column_index < x_cell_count)
      row = Array.new(y_cell_count)       # Create a new row array for each column
      @columns[column_index] = row        # Store the row array in the columns array
      row_index = 0                       # Initialize row index

      # Create Cell objects for each cell position
      while (row_index < y_cell_count)
        cell = Cell.new()                 # Create a new Cell object
        @columns[column_index][row_index] = cell  # Store the Cell object in the grid
        row_index += 1                    # Move to the next row
      end

      column_index += 1                   # Move to the next column
    end

    # Set up neighbor links for each cell in the grid
    column_index = 0                      # Reset column index for neighbor linking
    while (column_index < x_cell_count)
      row_index = 0                       # Reset row index for neighbor linking

      # Link neighboring cells (north, south, east, west) for each cell
      while (row_index < y_cell_count)
        # Link to the north cell if it exists
        if (row_index > 0 && row_index < y_cell_count)
          @columns[column_index][row_index].north = @columns[column_index][row_index - 1]
        else
          @columns[column_index][row_index].north = nil
        end

        # Link to the south cell if it exists
        if (row_index > -1 && row_index < y_cell_count - 1)
          @columns[column_index][row_index].south = @columns[column_index][row_index + 1]
        else
          @columns[column_index][row_index].south = nil
        end

        # Link to the east cell if it exists
        if (column_index > -1 && column_index < x_cell_count - 1)
          @columns[column_index][row_index].east = @columns[column_index + 1][row_index]
        else
          @columns[column_index][row_index].east = nil
        end

        # Link to the west cell if it exists
        if (column_index > 0 && column_index < x_cell_count)
          @columns[column_index][row_index].west = @columns[column_index - 1][row_index]
        else
          @columns[column_index][row_index].west = nil
        end

        row_index += 1                    # Move to the next row
      end

      column_index += 1                   # Move to the next column
    end
  end

  # Method to print information about each cell for debugging purposes
  def print_cells
    column_index = 0                      # Initialize column index
    x_cell_count = MAP_WIDTH / CELL_DIM   # Calculate number of cells in the x-direction
    y_cell_count = MAP_HEIGHT / CELL_DIM  # Calculate number of cells in the y-direction

    # Loop through each cell in the grid and print its attributes
    while (column_index < x_cell_count)
      row_index = 0                       # Initialize row index

      while (row_index < y_cell_count)
        # Determine if the cell has a north neighbor
        if (@columns[column_index][row_index].north == nil)
          north = 0                       # Set north to 0 if no neighbor
        else
          north = 1                       # Set north to 1 if neighbor exists
        end

        # Determine if the cell has a south neighbor
        if (@columns[column_index][row_index].south == nil)
          south = 0                       # Set south to 0 if no neighbor
        else
          south = 1                       # Set south to 1 if neighbor exists
        end

        # Determine if the cell has an east neighbor
        if (@columns[column_index][row_index].east == nil)
          east = 0                        # Set east to 0 if no neighbor
        else
          east = 1                        # Set east to 1 if neighbor exists
        end

        # Determine if the cell has a west neighbor
        if (@columns[column_index][row_index].west == nil)
          west = 0                        # Set west to 0 if no neighbor
        else
          west = 1                        # Set west to 1 if neighbor exists
        end

        # Print cell coordinates and neighbor information
        puts ("Cell x: " + column_index.to_s + ", y: " + row_index.to_s +
              " north: " + north.to_s + " south: " + south.to_s +
              " east: " + east.to_s + " west: " + west.to_s)

        row_index += 1                    # Move to the next row
      end

      puts ("------------ End of Column ------------")  # Separate columns for clarity
      column_index += 1                   # Move to the next column
    end
  end

  # Method to determine if the cursor should be displayed
  def needs_cursor?
    true                                # Return true to display the cursor
  end

  # Method to determine which cell the mouse cursor is over
  # and return its coordinates as an array
  def mouse_over_cell(mouse_x, mouse_y)
    # Determine x-coordinate of the cell the mouse is over
    if mouse_x <= CELL_DIM
      cell_x = 0                         # Mouse is in the first cell in x-direction
    else
      cell_x = (mouse_x / CELL_DIM).to_i  # Calculate cell index based on mouse position
    end

    # Determine y-coordinate of the cell the mouse is over
    if mouse_y <= CELL_DIM
      cell_y = 0                         # Mouse is in the first cell in y-direction
    else
      cell_y = (mouse_y / CELL_DIM).to_i  # Calculate cell index based on mouse position
    end

    [cell_x, cell_y]                     # Return array of cell coordinates
  end

  # Method to initiate a recursive path search starting from the selected cell
  # Not currently implemented for Maze Creation task
  def search(cell_x ,cell_y)
    # Initialize flags for path search
    dead_end = false
    path_found = false

    # Check if reached the east wall, terminate path search
    if (cell_x == ((MAP_WIDTH / CELL_DIM) - 1))
      if (ARGV.length > 0)                # Debugging output if command line argument is present
        puts "End of one path x: " + cell_x.to_s + " y: " + cell_y.to_s
      end

      [[cell_x,cell_y]]                   # Return the endpoint of the path
    else
      north_path = nil
      west_path = nil
      east_path = nil
      south_path = nil

      if (ARGV.length > 0)                # Debugging output if command line argument is present
        puts "Searching. In cell x: " + cell_x.to_s + " y: " + cell_y.to_s
      end

      # Missing code here: Perform recursive search in all directions (north, south, east, west)
      # based on vacant, visited, and on_path attributes of cells.
      # Cells on the outer boundaries will always have nil on the boundary side.

      # Choose one of the available paths if found
      if (north_path != nil)
        path = north_path
      elsif (south_path != nil)
        path = south_path
      elsif (east_path != nil)
        path = east_path
      elsif (west_path != nil)
        path = west_path
      end

      # If a path is found, return the complete path
      if (path != nil)
        if (ARGV.length > 0)              # Debugging output if command line argument is present
          puts "Added x: " + cell_x.to_s + " y: " + cell_y.to_s
        end

        [[cell_x,cell_y]].concat(path)    # Return the complete path
      else
        if (ARGV.length > 0)              # Debugging output if command line argument is present
          puts "Dead end x: " + cell_x.to_s + " y: " + cell_y.to_s
        end

        nil                               # Return nil if no path is found (dead end)
      end
    end
  end

  # Method to handle mouse button press events
  def button_down(id)
    case id
      when Gosu::MsLeft
        cell = mouse_over_cell(mouse_x, mouse_y)  # Get cell coordinates clicked by left mouse button
        puts("Cell clicked on is x: " + cell[0].to_s + " y: " + cell[1].to_s)
        @columns[cell[0]][cell[1]].vacant = true  # Mark the cell as vacant (left click)
      when Gosu::MsRight
        cell = mouse_over_cell(mouse_x, mouse_y)  # Get cell coordinates clicked by right mouse button
        @path = search(cell[0],cell[1])           # Initiate path search from the clicked cell (right click)
    end
  end

  # Method to walk along the found path and mark cells as part of the path
  def walk(path)
    index = path.length                     # Determine number of steps in the path
    count = 0                               # Initialize step count

    # Loop through each step in the path and mark cells as part of the path
    while (count < index)
      cell = path[count]                    # Get cell coordinates from the path
      @columns[cell[0]][cell[1]].on_path = true  # Mark cell as part of the path
      count += 1                            # Move to the next step in the path
    end
  end

  # Method to update the game state
  def update
    if (@path != nil)                       # Check if a path has been found
      if (ARGV.length > 0)                  # Debugging output if command line argument is present
        puts "Displaying path"
        puts @path.to_s
      end

      walk(@path)                           # Walk along the found path and mark cells
      @path = nil                           # Reset path variable after marking the path
    end
  end

  # Method to draw (or redraw) the game window
  def draw
    index = 0                               # Initialize index for drawing
    x_loc = 0                               # Initialize x-coordinate for drawing
    y_loc = 0                               # Initialize y-coordinate for drawing

    x_cell_count = MAP_WIDTH / CELL_DIM # Calculate number of cells in the x-direction
    y_cell_count = MAP_HEIGHT / CELL_DIM# Calculate number of cells in the y-direction

    column_index = 0# Initialize column index for drawing

    # Loop through each cell in the grid and draw it
    while (column_index < x_cell_count)
      row_index = 0# Initialize row index for drawing

      while (row_index < y_cell_count)
        # Determine cell color based on its state (vacant, on_path)
        if (@columns[column_index][row_index].vacant)
          color = Gosu::Color::YELLOW# Set color to yellow if cell is vacant
        else
          color = Gosu::Color::GREEN# Set color to green if cell is a wall
        end

        if (@columns[column_index][row_index].on_path)
          color = Gosu::Color::RED# Set color to red if cell is part of the path
        end

        # Draw rectangle representing the cell with determined color
        Gosu.draw_rect(column_index * CELL_DIM, row_index * CELL_DIM, CELL_DIM, CELL_DIM, color, ZOrder::TOP, mode=:default)

        row_index += 1# Move to the next row
      end

      column_index += 1# Move to the next column
    end
  end
end

# Create and run an instance of GameWindow
window = GameWindow.new
window.print_cells
window.show
