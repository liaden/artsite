class AddDescriptionToShow < ActiveRecord::Migration
  def change
    add_column :shows, :description, :text, :default => ''
  end
end
