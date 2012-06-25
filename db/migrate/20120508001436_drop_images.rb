class DropImages < ActiveRecord::Migration
  def up
    drop_table :images
  end

  def down
  end
end
