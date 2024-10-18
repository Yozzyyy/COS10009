require './input_functions'

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock'] # genre class set

class Album
    attr_accessor :artist, :title, :label, :genre, :tracks # class for each variable in album

    def initialize(artist, title, label, genre, tracks) # initializing each variable into each class set
        @artist = artist # artist variable
        @title = title # title variable
        @label = label # label variable
        @genre = genre # genre variable
        @tracks = tracks # tracks variables
    end
end

class Track
    attr_accessor :name, :location # class for each variable in Track

    def initialize(name, location) # initializing each variable into each class set
        @name = name # title variable in "Track"
        @location = location # location variable in "Track"
    end
end

def read_track(music_file)
    track_name = music_file.gets()
    track_location = music_file.gets()
    return Track.new(track_name, track_location)
end

def read_tracks(music_file)
    count = music_file.gets().to_i()
    tracks = Array.new()

    index = 0
    while (index < count)
        track = read_track(music_file)
        tracks << track
        index += 1
    end

    return tracks
end

def read_album(music_file)
    album_artist = music_file.gets()
    album_title = music_file.gets()
    album_label = music_file.gets()
    album_genre = music_file.gets()
    tracks = read_tracks(music_file)

    album = Album.new(album_artist, album_title, album_label, album_genre, tracks)
    return album
end

def read_albums(music_file)
    count = music_file.gets.chomp.to_i
    index = 0
    albums = Array.new()
    while index < count
        album = read_album(music_file)
        albums << album
        index += 1
    end
    return albums
end

def display_album(album)
    print("Title: " + album.title.chomp + " ")
    print("Artist: " + album.artist.chomp + " ")
    print("Label: " + album.label.chomp + " ")
    print("Genre: " + $genre_names[album.genre.to_i].chomp)
end

def display_albums(albums)
    if albums.empty?
        puts "No albums have been read. Select option 1 to read albums."
        return
    end
    finished = false
    while not finished
        puts ""
        puts 'Display Album Menu:'
        puts '1 Display all Albums'
        puts '2 Display Albums by Genre'
        puts '3 Back to Main Menu'
        choice = read_integer_in_range("Please enter your choice:", 1, 3)
        case choice
        when 1
            display_all_albums(albums)
        when 2
            display_album_genre(albums)
        when 3
            finished = true
        else
            puts "Please select again"
        end
    end
end

def display_all_albums(albums)
    index = 0
    puts("")
    while index < albums.length
        number = index + 1
        print(number.to_s + ": ")
        display_album(albums[index])
        puts("")
        index += 1
    end
end

def display_album_genre(albums)
    index = 1
    while (index < $genre_names.length)
        puts(index.to_s + ". " + $genre_names[index])
        index += 1
    end
    choice = read_integer_in_range("Pick a Genre:", 1, 4)
    puts("")
    display_albums_by_genre(choice, albums)
end

def display_albums_by_genre(choice, albums)
    index = 0
    found = false
    while (index < albums.length)
        if (albums[index].genre.to_i == choice)
            print(" ")
            display_album(albums[index])
            puts("")
            found = true
        end
        index += 1
    end

    if (!found)
        puts("There are no albums in the genre you selected.")
    end
end

def play_album(albums)
    if albums.empty?
        puts "No albums have been read. Select option 1 to read albums."
        return
    end
    display_all_albums(albums)
    album_number = read_integer_in_range("Enter Album number:", 1, albums.length)
    album_index = album_number - 1
    print(" ")
    display_album(albums[album_index])
    puts("\n\n")

    track_number = albums[album_index].tracks.length
    index = 0
    while (index < track_number)
        number = index + 1
        puts(number.to_s + " Track name: " + albums[album_index].tracks[index].name + " Track location: " + albums[album_index].tracks[index].location)
        index += 1
    end

    if (track_number == 0)
        puts("There is no track in this album.")
    else
        choice = read_integer_in_range("Select a Track to play:", 1, track_number)
        puts("Playing track " + albums[album_index].tracks[choice - 1].name.chomp + " from album " + albums[album_index].title)
    end
    sleep(3)
    return albums
end

def add_album(albums)
    album_title = read_string("Enter title:") #read the title
    album_artist = read_string("Enter artist:") #read the new artist
    album_label = read_string("Enter label:") #read the new label

    puts "1. Pop"
    puts "2. Classic"
    puts "3. Jazz"
    puts "4. Rock"
    album_genre = read_integer_in_range("Enter number of genre:", 1, 4).to_s #read genre

    num_tracks = read_integer("Enter number of tracks:") #read number of tracks

    tracks = []
    index = 0
    while index < num_tracks
        track_name = read_string("Enter a name for the new track:") #new track
        track_location = read_string("Enter a location for the new track:") #new location
        tracks << Track.new(track_name, track_location) #new array list
        index += 1
    end

    albums << Album.new(album_artist, album_title, album_label, album_genre, tracks)
    puts "Album added: #{album_title}. Press enter to continue."
    gets
end

def main()
    finished = false
    albums = []
    while not finished
        puts ""
        puts 'Main Menu:'
        puts '1. Read in Albums'
        puts '2. Display Albums'
        puts '3. Select an Album to play'
        puts '4. Add an Album'
        puts '5. Exit the application'
        choice = read_integer_in_range("Please enter your choice:", 1, 5)
        case choice
        when 1
            file = read_string("Enter a file path to an Album:")
            if File.exist?(file)
                music_file = File.new(file, "r")
                new_albums = read_albums(music_file)
                albums.concat(new_albums)
                music_file.close
            else
                puts("\nIncorrect file path.")
            end
        when 2
            display_albums(albums)
        when 3
            play_album(albums)
        when 4
            add_album(albums)
        when 5
            finished = true
        else
            puts "Please select again"
        end
    end
end

main()

