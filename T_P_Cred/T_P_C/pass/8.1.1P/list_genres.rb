
# put the genre names array here:
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

def main()

    index = 1
    while (index < $genre_names.length)
        puts(index.to_s + " " + $genre_names[index])
        index += 1
    end

end

main()
