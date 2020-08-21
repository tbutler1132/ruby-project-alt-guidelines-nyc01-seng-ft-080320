class User < ActiveRecord::Base
    has_many :collections
    has_many :albums, through: :collections


    def self.log_in(user_name)
        User.find_by(name: user_name)
    end
    
    def self.sign_up_or_log_in
        prompt = TTY::Prompt.new
        new_user_name = prompt.ask("Please input your first name:")
        new_user_age = prompt.ask("Please input your age:") 
        new_user_location = prompt.ask("Please input your location:")
        User.find_or_create_by(name: new_user_name, age: new_user_age, location: new_user_location)
     end
    
    def artists    
        self.albums.map do |album|
            album.artist
        end
    end

    def favorite_artist
        self.artists.max_by {|i| self.artists.count(i)}
    end 
    
    def delete_album(album_title)   
            album_to_delete = self.albums.find_by(title: album_title)
            self.albums.delete(album_to_delete)
    end

    def add_album(new_album = nil, new_title = nil, new_artist = nil, new_genre = nil, new_label = nil)   #maybe could refactor using find_or_create_by ?
        if Album.album_in_database?(new_album)
            if self.albums.include?(new_album)
                puts "That album is already in your collection."
            else
            Collection.create(user: self, album: new_album)
            end
        else
            created_album = Album.create(title: new_title, artist: new_artist, genre: new_genre, label: new_label)
            Collection.create(user: self, album: created_album)
        end
    end

    def eligible_for_match?
        self.albums.count > 2
    end 
    
    def match
        array_of_albums = []
        user_albums = self.albums
        array_of_common = []
         User.all.each do |user|
             array_of_albums << user.albums
         end
         array_of_albums.each do |album_array|
          common_test = album_array & user_albums   
            array_of_common << common_test
        end
         num_in_common = array_of_common.map do |common|
             common.count
         end
         most_in_common = num_in_common.sort[-2]
         index_of_answer = num_in_common.index(most_in_common)
         User.all[index_of_answer]
     end

     def percent_in_common
            total_in_common = self.match.albums & self.albums
            match = total_in_common.count / self.albums.count.to_f * 100
            match.to_i
     end

     def self.exist?(user_name)         ##### Can call directly using exists?(name)
        User.all.include?(User.find_by(name: user_name))
     end

    def view_matches_albums
        prompt = TTY::Prompt.new
        choice = prompt.yes?("Would you like to view your matches' albums")
        if choice == true 
            Collection.display_albums(self.match)
        end
    end


    def existing_member_prompt
        prompt = TTY::Prompt.new
            choice = prompt.select("Welcome #{self.name}. Would you like to view your albums or match?", %w(albums match))
            if choice == "albums"
                if self.albums.count == 0
                puts "Yikes! You have no albums!"
                else
                    Collection.display_albums(self)
                end
            else choice == "match"
                if self.eligible_for_match?
                    puts "Your match is #{self.match.name}. They are located in #{self.match.location} and their favorite artist is #{self.match.favorite_artist}. Your match rate is #{self.percent_in_common}%!"
                    self.view_matches_albums
                else
                    puts "Add more albums to find a match!"
                end
            end
    end
    
     def new_user_prompt 
     puts "Welcome #{self.name}! To get started, please add 3 or more albums to your collection!"   
        while Collection.display_albums(self).count < 3
            puts "Please input an album title."   
            album_title = gets.chomp
            if Album.album_in_database?(Album.find_by(title: album_title))      
                self.add_album(Album.find_by(title: album_title))
                Collection.display_albums(self)
            else
                puts "Please input the album artist"
                album_artist = gets.chomp
                puts "Please input the album genre"
                album_genre = gets.chomp
                puts "Please input the album label"
                album_label = gets.chomp
                self.add_album(nil, album_title, album_artist, album_genre, album_label)   ####BUGGED####
            end
        end
        prompt = TTY::Prompt.new
        choice = prompt.yes?("Awesome, would you like to see if you have a match?")
        if choice == true
            puts "Your match is #{self.match.name}. Your match rate is #{self.percent_in_common}%!"
        end
    end

    def add_delete_prompt
        prompt = TTY::Prompt.new
        choices = {"add" => 1, "delete" => 2, "I just want to view my collection" => 3}
        choice = prompt.select("Would you like to add or delete an album from your collection?", choices)
        if choice == choices["delete"]
            Collection.display_albums(self)
            puts "Which album would you like to delete?"
            album_title = gets.chomp
            self.delete_album(album_title)
            Collection.display_albums(self)
        elsif choice == choices["add"]
            puts "Please input the album title."
            album_title = gets.chomp
            if Album.album_in_database?(Album.find_by(title: album_title))     
                self.add_album(Album.find_by(title: album_title))
                Collection.display_albums(self)
            else
                puts "Please input the album artist"
                album_artist = gets.chomp
                puts "Please input the album genre"
                album_genre = gets.chomp
                puts "Please input the album label"
                album_label = gets.chomp
                self.add_album(nil, album_title, album_artist, album_genre, album_label)
            end
        else choice == choices["I just want to view my collection"]
            Collection.display_albums(self)
        end
    end

    def view_popularity
        prompt = TTY::Prompt.new
        choices = {"Album!" => 1, "Artist" => 2, "Genre" => 3, "I'm good." => 4}
        choice = prompt.select("Would you like to view what's most popular?", choices)
        if choice == choices["Album!"]
            puts Album.most_popular.italic + " is our most popular album!"
        elsif choice == choices["Artist"]
            puts "Feature coming soon!"
        elsif choice == choices["Genre"]
            puts "Feature coming soon!"
        end
    end
     
end