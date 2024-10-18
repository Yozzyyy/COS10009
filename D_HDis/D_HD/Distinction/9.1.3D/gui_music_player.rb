require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)     # Define top background color
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)  # Define bottom background color

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2             # Define drawing order constants
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4           # Define genre constants
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']  # Define genre names

class ArtWork
  attr_accessor :bmp                        # Accessor for artwork image

  def initialize(file)
    @bmp = Gosu::Image.new(file)            # Initialize artwork with image file
  end
end

class Album
  attr_accessor :title, :artist, :artwork, :tracks  # Accessors for album attributes

  def initialize(title, artist, artwork, tracks)
    @title = title                          # Initialize album title
    @artist = artist                        # Initialize album artist
    @artwork = artwork                     # Initialize album artwork
    @tracks = tracks                        # Initialize album tracks
  end
end

class Track
  attr_accessor :name, :location            # Accessors for track attributes

  def initialize(name, location)
    @name = name                            # Initialize track name
    @location = location                    # Initialize track location
  end
end

class Song
  attr_accessor :song                      # Accessor for song

  def initialize(file)
    @song = Gosu::Song.new(file)           # Initialize song with audio file
  end
end

class MusicPlayerMain < Gosu::Window
  def initialize
    super 600, 800                          # Initialize window dimensions
    self.caption = "Music Player"           # Set window caption
    @locs = [60, 60]                        # Initialize location array
    @selected_album = nil                   # Initialize selected album
    @track_font = Gosu::Font.new(25)        # Initialize track font
    @playing_font = Gosu::Font.new(35)      # Initialize playing font
    @now_playing_message = nil              # Initialize now playing message
    @albums = load_album()                  # Load albums from file
  end

  def load_album
    # Methods for reading albums and tracks from a file
    def read_track(music_file)
      track_name = music_file.gets()         # Read track name
      track_location = music_file.gets().chomp  # Read track location
      return Track.new(track_name, track_location)  # Return new track object
    end

    def read_tracks(music_file)
      count = music_file.gets().to_i         # Read number of tracks
      tracks = Array.new()                   # Initialize tracks array

      index = 0
      while index < count
        track = read_track(music_file)       # Read each track
        tracks << track                      # Add track to array
        index += 1
      end

      return tracks                          # Return tracks array
    end

    def read_album(music_file)
      album_title = music_file.gets().chomp   # Read album title
      album_artist = music_file.gets().chomp  # Read album artist
      album_artwork = music_file.gets().chomp  # Read album artwork
      tracks = read_tracks(music_file)        # Read album tracks

      album = Album.new(album_title, album_artist, album_artwork, tracks)  # Create album object
      return album                            # Return album object
    end

    def read_albums(music_file)
      count = music_file.gets.chomp.to_i       # Read number of albums
      index = 0
      albums = Array.new()                     # Initialize albums array
      while index < count
        album = read_album(music_file)         # Read each album
        albums << album                        # Add album to array
        index += 1
      end
      return albums                            # Return albums array
    end

    music_file = File.new("music.txt", "r")    # Open music file for reading
    albums = read_albums(music_file)           # Read all albums from file

    music_file.close()                         # Close music file
    return albums                              # Return albums array
  end

  def draw_albums(albums)
    # Draw album artwork on the screen for all albums
    @bmp = Gosu::Image.new(albums[0].artwork)  # Load and draw first album artwork
    @bmp.draw(60, 30 , z = ZOrder::UI)         # Draw first album artwork

    @bmp = Gosu::Image.new(albums[1].artwork)  # Load and draw second album artwork
    @bmp.draw(60, 270, z = ZOrder::UI)         # Draw second album artwork

    @bmp = Gosu::Image.new(albums[2].artwork)  # Load and draw third album artwork
    @bmp.draw(330, 30 , z = ZOrder::UI)        # Draw third album artwork

    @bmp = Gosu::Image.new(albums[3].artwork)  # Load and draw fourth album artwork
    @bmp.draw(330, 270, z = ZOrder::UI)        # Draw fourth album artwork
  end

  def area_clicked(mouse_x, mouse_y)
    # Detect if a mouse sensitive area (album artwork) has been clicked
    @change_background1 = false
    @change_background2 = false
    @change_background3 = false
    @change_background4 = false

    if (mouse_x > 60 and mouse_x < 270) and (mouse_y > 30 and mouse_y < 240)
      @selected_album = 0                    # Set selected album to first album
      @change_background1 = true             # Indicate change in background
    end
    if (mouse_x > 60 and mouse_x < 270) and (mouse_y > 270 and mouse_y < 480)
      @selected_album = 1                    # Set selected album to second album
      @change_background2 = true             # Indicate change in background
    end
    if (mouse_x > 330 and mouse_x < 540) and (mouse_y > 30 and mouse_y < 240)
      @selected_album = 2                    # Set selected album to third album
      @change_background3 = true             # Indicate change in background
    end
    if (mouse_x > 330 and mouse_x < 540) and (mouse_y > 270 and mouse_y < 480)
      @selected_album = 3                    # Set selected album to fourth album
      @change_background4 = true             # Indicate change in background
    end
  end

  def display_track(title, ypos)
    # Display track title on the screen
    @track_font.draw(title, 60, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK) #track songs after clicking on selected album
  end

  def playTrack(track, album)
    # Play the selected track from the album
    @song = Gosu::Song.new(album.tracks[track].location)  # Load selected track
    @song.play(false)                                     # Play the track once
  end

  def draw_background
    # Draw a colored background using predefined top and bottom colors
    draw_quad(0, 0, TOP_COLOR, 0, 800, TOP_COLOR, 600, 0, BOTTOM_COLOR, 600, 800, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
  end

  def update
    @hovered_album = nil  # Reset hovered album

    # Check if the mouse is over each album's artwork
    if mouse_x > 60 && mouse_x < 270 && mouse_y > 30 && mouse_y < 240
      @hovered_album = 0  # Set hovered album to first album
    elsif mouse_x > 330 && mouse_x < 540 && mouse_y > 30 && mouse_y < 240
      @hovered_album = 1  # Set hovered album to second album
    elsif mouse_x > 60 && mouse_x < 270 && mouse_y > 270 && mouse_y < 480
      @hovered_album = 2  # Set hovered album to third album
    elsif mouse_x > 330 && mouse_x < 540 && mouse_y > 270 && mouse_y < 480
      @hovered_album = 3  # Set hovered album to fourth album
    end
  end

  def draw
    albums = @albums  # Assign albums array to local variable

    draw_background  # Draw the colored background
    draw_albums(albums)  # Draw all album artworks

    # Draw a border around the hovered album's artwork
    if @hovered_album
      case @hovered_album
      when 0
        Gosu.draw_rect(58, 28, 214, 214, Gosu::Color::GREEN, ZOrder::PLAYER)
      when 1
        Gosu.draw_rect(328, 28, 214, 214, Gosu::Color::WHITE, ZOrder::PLAYER)
      when 2
        Gosu.draw_rect(58, 268, 214, 214, Gosu::Color::BLUE, ZOrder::PLAYER)
      when 3
        Gosu.draw_rect(328, 268, 214, 214, Gosu::Color::BLACK, ZOrder::PLAYER)
      end
    end

    # Change background color based on selected album and dim other albums
    if @selected_album
      case @selected_album
      when 0 #change colour for album 1
        Gosu.draw_rect(0, 0, 600, 800, Gosu::Color.argb(0xFF_FFD1DC), ZOrder::BACKGROUND)# set bg colour
        Gosu.draw_rect(60, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI) #dim all 3 other album
        Gosu.draw_rect(330, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
        Gosu.draw_rect(330, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
      when 1
        Gosu.draw_rect(0, 0, 600, 800, Gosu::Color.argb(0xFF_45C4B6), ZOrder::BACKGROUND)# set bg colour
        Gosu.draw_rect(60, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)#dim all 3 other album
        Gosu.draw_rect(330, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
        Gosu.draw_rect(330, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
      when 2
        Gosu.draw_rect(0, 0, 600, 800, Gosu::Color.argb(0xFF_C713F7), ZOrder::BACKGROUND)# set bg colour
        Gosu.draw_rect(60, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)#dim all 3 other album
        Gosu.draw_rect(60, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
        Gosu.draw_rect(330, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
      when 3
        Gosu.draw_rect(0, 0, 600, 800, Gosu::Color.argb(0xFF_EC7C86), ZOrder::BACKGROUND)# set bg colour
        Gosu.draw_rect(60, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)#dim all 3 other album
        Gosu.draw_rect(60, 270, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
        Gosu.draw_rect(330, 30, 210, 210, Gosu::Color.new(160, 0, 0, 0), ZOrder::UI)
      end
    end

    # Display tracks of the selected album and now playing message
    if @selected_album
      album = albums[@selected_album]       # Get selected album
      y_position = 500

      i = 0
      while i < album.tracks.length
        track = album.tracks[i]             # Get each track
        display_track(track.name, y_position)  # Display track name
        y_position += 35                    # Increment y position
        i += 1
      end

      if @now_playing_message
        @playing_font.draw_text(@now_playing_message, 60, 700, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)  # Draw now playing message
      end
    end
  end

  def needs_cursor?
    true  # Enable cursor visibility
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      @locs = [mouse_x, mouse_y]            # Store mouse location
      area_clicked(mouse_x, mouse_y)        # Check if an area was clicked

      if @selected_album
        album = @albums[@selected_album]    # Get selected album
        y_position = 500

        i = 0
        while i < album.tracks.length
          track = album.tracks[i]           # Get each track
          if mouse_x > 60 && mouse_x < 540 && mouse_y > y_position && mouse_y < y_position + 35
            playTrack(i, album)             # Play selected track
            @now_playing_message = "Now Playing: #{track.name} from #{album.title} by #{album.artist}"  # Update now playing message
          end
          y_position += 35                 # Increment y position
          i += 1
        end
      end
    end
  end
end

# Create and show an instance of MusicPlayerMain window
MusicPlayerMain.new.show if __FILE__ == $0
