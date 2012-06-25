class AddPriceToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :price, :integer

  end
end
