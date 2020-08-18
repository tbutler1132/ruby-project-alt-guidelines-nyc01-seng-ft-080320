require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'


def run
    puts "Welcome. Input your, name:"
    user_name = gets.chomp
    current_user = User.find_by(name: user_name)
    puts "Hi, #{current_user.name}, would you like to see your albums or your match?"
    choice = gets.chomp
    if choice == "albums"
        display_albums = current_user.albums
    else choice == "match"
        display_match = current_user.match.name
    end
    binding.pry
end
   
run 