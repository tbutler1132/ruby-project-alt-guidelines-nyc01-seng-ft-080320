class User < ActiveRecord::Base
    has_many :collections
    has_many :albums, through: :collections

   
    def delete_album(album)
        album.delete
    end

    def add_album(new_album=nil, new_title=nil, new_genre=nil, new_artist=nil, new_label=nil)
        if Album.all.include?(new_album)
            Collection.create(user: self, album: new_album)
        else
            created_album = Album.create(title: new_title, genre: new_genre, artist: new_artist, label: new_label)
            Collection.create(user: self, album: created_album)
        end
    end
            
   
    #iterate over User.all grabbing the array of albums and shoveling them into a hash of arrays. Hash key == user id, and Hash value == array.of albums.
    #than iterate over the hash, returning the id of the array that has the most items in common with the self.albums array.

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


end