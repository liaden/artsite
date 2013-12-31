class AddFrameRelationToPrintOrder < ActiveRecord::Migration
  def change
    remove_column :print_orders, :frame_size
    add_column :print_orders, :frame_id, :integer
  end
end
