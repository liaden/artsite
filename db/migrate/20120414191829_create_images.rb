class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :filename
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
