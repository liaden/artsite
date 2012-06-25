class UpdatePriceOnPrint < ActiveRecord::Migration
  def up
    remove_column :prints, :price
    add_column :prints, :price, :decimal
  end

  def down
  end
end
