class Album < ActiveRecord::Base
    has_many :collections
    has_many :users, through: :collections

def self.most_popular_album
        most_users = Album.all.map do |album|
            album.users.count
        end.max
        Album.all.find do |album|
            album.users.count == most_users
        end
    end
end