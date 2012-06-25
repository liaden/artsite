class AddDescriptionToArtwork < ActiveRecord::Migration
  def change
    add_column :artworks, :description, :string

  end
end
