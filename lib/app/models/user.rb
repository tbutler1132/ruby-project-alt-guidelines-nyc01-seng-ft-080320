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
            
   
    #self


#     def match
#         self.each do |user|
#             user.each |album|
#                 album.
#         end
#     end

end