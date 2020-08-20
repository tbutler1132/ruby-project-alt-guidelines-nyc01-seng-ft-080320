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

    # def display_albums
    #     album_instance = self.collections.map do |collection|
    #         collection.album
    #     end
    #     album_instance.each do |album|
    #         puts album.artist + " - " + album.title.italic
    #     end
    # end
    
    # def display_albums
    #     sorted = self.albums.sort_by {|album| album.artist}
    #     sorted.each do |album|
    #         puts album.artist + " - " + album.title.italic
    #     end
    # end
    
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
        if self.albums.count > 2
            total_in_common = self.match.albums & self.albums
            match = total_in_common.count / self.albums.count.to_f * 100
            match.to_i
        else 
            puts "Add more albums to find a match!"
        end
     end

     def self.log_in
        prompt = TTY::Prompt.new
        user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
        User.find_by(name: user_name)
     end
     
end