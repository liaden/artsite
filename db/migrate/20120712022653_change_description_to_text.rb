class ChangeDescriptionToText < ActiveRecord::Migration
  def up
    remove_column :artworks, :description
    add_column :artworks, :description, :text
  end

  def down
  end
end
