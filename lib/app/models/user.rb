class User < ActiveRecord::Base
    has_many :collections
    has_many :albums, through: :collections

   
    # def user_owns_album?(album_title)     ####TEST####
    #     self.albums.include? do |album|
    #         album.title == album_title
    # end

    
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

    def add_album(new_album = nil, new_title = nil, new_artist = nil, new_genre = nil, new_label = nil)        #######If album is already in collection?
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

     def self.log_in(user_name)
            User.find_by(name: user_name)
     end

     def self.sign_up
        prompt = TTY::Prompt.new
        new_user_name = prompt.ask("Please input your first name:")
        new_user_age = prompt.ask("Please input your age:") 
        new_user_location = prompt.ask("Please input your location:")
        User.find_or_create_by(name: new_user_name, age: new_user_age, location: new_user_location)
     end

     def self.exist?(user_name)
        User.all.include?(User.find_by(name: user_name))
     end

     def self.log_in_or_sign_up
        User.find_or_create_by(name: "Tim", age: 23, location: "New York")
     end
     
end