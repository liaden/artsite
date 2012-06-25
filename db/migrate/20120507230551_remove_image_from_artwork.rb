class RemoveImageFromArtwork < ActiveRecord::Migration
  def up
    remove_column :artworks, :image
  end

  def down
  end
end
