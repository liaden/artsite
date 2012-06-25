class AddPlacedTimeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :placed_at, :datetime

  end
end
