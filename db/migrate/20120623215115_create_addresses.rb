class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :recipient
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
