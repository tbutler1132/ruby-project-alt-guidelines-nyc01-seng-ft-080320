require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'

# puts String.color_samples

def run
    prompt = TTY::Prompt.new 
    member = prompt.yes?("Are you already a member?")
    if member == true
        user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
        if User.exist?(user_name)
            current_user = User.log_in(user_name)
        else
            puts "We don't recognize you. Please input the following info and you will either be signed in or a new account will be created:"
            current_user = User.sign_up_or_log_in 
        end
    else member == false
        current_user = User.sign_up_or_log_in 
    end
    
system "clear"
    choice = prompt.select("Welcome #{current_user.name}. Would you like to view your albums or match?", %w(albums match))
    if choice == "albums"
        if current_user.albums.count == 0
            puts "Yikes! You have no albums!"
        else
            Collection.display_albums(current_user)
        end
    else choice == "match"
        if current_user.eligible_for_match?
            puts "Your match is #{current_user.match.name}. Your match rate is #{current_user.percent_in_common}%!"
        else
            puts "Add more albums to find a match!"
        end
    end
    choices = {"add" => 1, "delete" => 2, "I just want to view my collection" => 3}
    choice = prompt.select("Would you like to add or delete an album from your collection?", choices)

system "clear"
    if choice == choices["delete"]
        Collection.display_albums(current_user)
        puts "Which album would you like to delete?"
        album_title = gets.chomp
        current_user.delete_album(album_title)
        Collection.display_albums(current_user)
    elsif choice == choices["add"]
        puts "Please input the album title."
        album_title = gets.chomp
        if Album.album_in_database?(Album.find_by(title: album_title))     
            current_user.add_album(Album.find_by(title: album_title))
            Collection.display_albums(current_user)
        else
            puts "Please input the album artist"
            album_artist = gets.chomp
            puts "Please input the album genre"
            album_genre = gets.chomp
            puts "Please input the album label"
            album_label = gets.chomp
            current_user.add_album(nil, album_title, album_artist, album_genre, album_label)
        end
    else choice == choices["I just want to view my collection"]
        Collection.display_albums(current_user)
    end               
    
    choice = prompt.yes?("Would you like to view your current collection?")
system "clear"
    if choice == true
        Collection.display_albums(current_user)
    end
    

end
   
run 