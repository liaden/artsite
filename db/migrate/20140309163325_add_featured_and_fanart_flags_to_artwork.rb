class AddFeaturedAndFanartFlagsToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :featured, :boolean, :default => false
    add_column :artworks, :fanart, :boolean, :default => false
  end
end
