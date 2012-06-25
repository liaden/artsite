class AddShowTypeToShows < ActiveRecord::Migration
  def change
    add_column :shows, :show_type, :string

  end
end
