class RemovePriceFromLesson < ActiveRecord::Migration
  def up
    remove_column :lessons, :price
  end

  def down
  end
end
