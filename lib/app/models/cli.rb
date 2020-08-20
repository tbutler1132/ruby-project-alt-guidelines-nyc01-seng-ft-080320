require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'

# puts String.color_samples

def run
    prompt = TTY::Prompt.new 
    member = prompt.yes?("Are you already a member?")
    if member == true
        user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
        if User.all.include?(User.find_by(name: user_name))
            current_user = User.log_in(user_name)
        else
            while User.all.include?(User.find_by(name: user_name)) == false 
                user_name = prompt.ask("You are not a member. Please input a valid name or type: Sign up".white.on_light_black.bold)
                if User.all.include?(User.find_by(name: user_name)) == true
                    current_user = User.log_in(user_name)
                else user_name == "Sign Up"
                    new_user_name = prompt.ask("Please input your first name:")
                    new_user_age = prompt.ask("Please input your age:") 
                    new_user_location = prompt.ask("Please input your location:")
                    current_user = User.create(name: new_user_name, age: new_user_age, location: new_user_location)
                    break
                end
            end
        end
    else member == false
        new_user_name = prompt.ask("Please input your first name:")
        new_user_age = prompt.ask("Please input your age:") 
        new_user_location = prompt.ask("Please input your location:")
        current_user = User.create(name: new_user_name, age: new_user_age, location: new_user_location)
    end
system "clear"
    choice = prompt.select("Welcome #{current_user.name}. Would you like to view your albums or match?", %w(albums match))
    if choice == "albums"
        Collection.display_albums(current_user)
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
    elsif choice == choices["add"]
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
    else choice == choices["I just want to view my collection"]
        Collection.display_albums(current_user)
    end               
    choice = prompt.yes?("Would you like to view your current collection?")
system "clear"
    if choice == true
        Collection.display_albums(current_user)
    end
    
    # binding.pry

    # play_music()
    # pid = fork{ exec ‘afplay’, 'music/fill.mp3' }  

    # def play_music(file)
    #     @pid = spawn( 'afplay', file )
    # end

end
   
run 