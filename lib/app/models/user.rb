class User < ActiveRecord::Base
    belongs_to :collection
    has_many :albums, through: :collection

end