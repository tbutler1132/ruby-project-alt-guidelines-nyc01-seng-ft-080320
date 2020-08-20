require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'

# puts String.color_samples

def run
    prompt = TTY::Prompt.new
    # pid = fork{ exec ‘afplay’, 'music/fill.mp3' }   
    user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
    current_user = User.find_by(name: user_name)
system "clear"
    choice = prompt.select("Welcome #{current_user.name}. Would you like to view your albums or match?", %w(albums match))
    if choice == "albums"
        Collection.display_albums(current_user)
    else choice == "match"
            puts "Your match is #{current_user.match.name}. Your match rate is #{current_user.percent_in_common}%!"
    end
    choice = prompt.select("Would you like to add or delete an album from your collection?", %w(add delete))
system "clear"
    if choice == "delete"
        Collection.display_albums(current_user)
        puts "Which album would you like to delete?"
        album_title = gets.chomp
        current_user.delete_album(album_title)
    else choice == "add"
        puts "Please input the album title."
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
            current_user.add_album(nil, album_title, album_artist, album_genre, album_label)
        end
    end               
    choice = prompt.yes?("Your albums have been updated. Would you like to view your current collection?")
system "clear"
    if choice == true
        Collection.display_albums(current_user)
    end
    
    # binding.pry

    # play_music()


    # def play_music(file)
    #     @pid = spawn( 'afplay', file )
    # end

end
   
run 