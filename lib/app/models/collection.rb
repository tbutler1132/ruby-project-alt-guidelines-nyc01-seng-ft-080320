class Collection < ActiveRecord::Base
    belongs_to :user
    belongs_to :album

    def self.display_albums(user)    
        Catpix::print_image "lib/app/imgs/safe_image.jpeg",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => false,
  :resolution => "high"                               ### Can refactor using active record, written like this because it was not working in CLI
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