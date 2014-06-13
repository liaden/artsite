class RemoveDeadTables < ActiveRecord::Migration
  def up
    drop_table :ideas
    drop_table :frames
    drop_table :lessons
    drop_table :lesson_orders
    drop_table :mattes
    drop_table :recommended_matte_colors

    remove_column :print_orders, :frame_id
    remove_column :print_orders, :matte_id
    remove_column :prints, :frame_id
    remove_column :prints, :matte_id
  end

  def down
  end
end
