class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
      t.boolean :is_sold_out
      t.boolean :is_on_show
      t.integer :price
      t.integer :artwork_id
      t.string :size_name
      t.string :material
      t.string :dimensions

      t.timestamps
    end
  end
end
