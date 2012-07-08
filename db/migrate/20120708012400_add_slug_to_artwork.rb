class AddSlugToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :slug, :string
    add_index :artworks, :slug, :unique => true
  end
end
