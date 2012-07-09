class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.string :customer
      t.integer :width
      t.integer :height
      t.string :medium
      t.text :comments

      t.timestamps
    end
  end
end
