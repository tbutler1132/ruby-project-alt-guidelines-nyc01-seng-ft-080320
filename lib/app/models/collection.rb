class Collection < ActiveRecord::Base
    belongs_to :user
    belongs_to :album

    def self.display_albums(user)                                   ### Can refactor using active record, written like this because it was not working in CLI
        user_collections = Collection.all.filter do |collection|
            collection.user == user
        end 
        user_albums = user_collections.map do |collection|
            collection.album
        end
        user_albums.each do |album|
            puts album.artist + " - " + album.title.italic
        end
     end

end