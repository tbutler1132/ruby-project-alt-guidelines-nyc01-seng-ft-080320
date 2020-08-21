class Album < ActiveRecord::Base
    has_many :collections
    has_many :users, through: :collections


    def self.album_in_database?(album_to_check_for)  ###REFACTOR
        Album.all.include?(album_to_check_for)
    end

    def self.most_popular
        most_users = Album.all.map do |album|
            album.users.count
        end.max
        Album.all.find do |album|
            album.users.count == most_users
        end.title
    end


end