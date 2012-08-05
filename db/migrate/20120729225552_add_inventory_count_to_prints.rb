class AddInventoryCountToPrints < ActiveRecord::Migration
  def change
    add_column :prints, :inventory_count, :integer

  end
end
