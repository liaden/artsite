class AddImageToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :image_file_name, :string
    add_column :artworks, :image_content_type, :string
    add_column :artworks, :image_file_size, :string
  end
end
