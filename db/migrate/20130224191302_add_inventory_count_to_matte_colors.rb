class AddInventoryCountToMatteColors < ActiveRecord::Migration
  def change
    add_column :matte_colors, :inventory_count, :integer

  end
end
