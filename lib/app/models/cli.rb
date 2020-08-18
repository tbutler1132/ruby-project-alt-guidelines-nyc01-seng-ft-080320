require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'


def run
    puts "Welcome. Input your, name:"
    user_name = gets.chomp
    current_user = User.find_by(name: user_name)
    puts "Hi #{current_user.name}, would you like to see your albums or your match?"
    choice = gets.chomp
    if choice == "albums"
        current_user.albums.each do |album|
            puts album.artist + " - " + album.title
        end
    else choice == "match"
        puts "Your match is #{current_user.match.name}. Your match rate is #{current_user.percent_in_common}%!"
    end
    puts "Would you like to add or delete an album from your collection?"
    choice = gets.chomp
    if choice == "delete"
        puts "Which album would you like to delete?"
        album_title = gets.chomp
        current_user.delete_album(album_title)
    else choice == "add"
        puts "Please input the album title"
        album_title = gets.chomp
            if Album.album_in_database?(Album.find_by(title: album_title))
                current_user.add_album(Album.find_by(title: album_title))
            else
                puts "Please input the album artist"
                album_artist = gets.chomp
                puts "Please input the album genre"
                album_genre = gets.chomp
                puts "Please input the album label"
                album_label = gets.chomp
                current_user.add_album(nil, artist: album_artist, genre: album_genre, label: album_label)
            end
    end
    current_user.albums.each do |album|
        puts album.artist + " - " + album.title
    end
    # binding.pry
end
   
run 