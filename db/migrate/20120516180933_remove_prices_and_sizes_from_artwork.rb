class RemovePricesAndSizesFromArtwork < ActiveRecord::Migration
  def up
    remove_column :artworks, :small_size, :small_price, :medium_size, :medium_price, :large_size, :large_price, :original_size, :original_price, :is_original_sold
  end

  def down
  end
end
