class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :url
      t.string :title
      t.integer :mood

      t.timestamps
    end
  end
end
