class CreatePrintOrders < ActiveRecord::Migration
  def change
    create_table :print_orders do |t|
      t.integer :print_id
      t.integer :order_id

      t.timestamps
    end
  end
end
