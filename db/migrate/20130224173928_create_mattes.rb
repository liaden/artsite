class CreateMattes < ActiveRecord::Migration
  def change
    create_table :mattes do |t|
      t.integer :matte_color_id
      t.float :size

      t.timestamps
    end
  end
end
