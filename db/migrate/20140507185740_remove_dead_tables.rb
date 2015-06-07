class RemoveDeadTables < ActiveRecord::Migration
  def up
    drop_table :matte_colors 
  end

  def down
  end
end
