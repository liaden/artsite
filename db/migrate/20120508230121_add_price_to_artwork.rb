class AddPriceToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :small_price, :integer
    add_column :artworks, :small_size, :string
    
    add_column :artworks, :medium_price, :integer
    add_column :artworks, :medium_size, :string
    
    add_column :artworks, :large_price, :integer
    add_column :artworks, :large_size, :string

    add_column :artworks, :original_price, :integer
    add_column :artworks, :original_size, :string
    add_column :artworks, :is_original_sold, :boolean
  end
end
