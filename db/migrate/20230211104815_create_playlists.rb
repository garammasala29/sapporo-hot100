class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.string :track, null: false
      t.string :artist, null: false

      t.timestamps
    end
  end
end
