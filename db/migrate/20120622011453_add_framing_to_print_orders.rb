class AddFramingToPrintOrders < ActiveRecord::Migration
  def change
    add_column :print_orders, :frame_size, :string

  end
end
