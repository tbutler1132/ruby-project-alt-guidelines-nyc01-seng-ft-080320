class AddAlbumsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :title
      t.string :artist
      t.string :genre
      t.string :label
    end
  end
end
