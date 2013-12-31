class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.decimal :thickness
      t.decimal :depth
      t.decimal :price_per_inch
      t.integer :linear_inches
    end
  end
end

