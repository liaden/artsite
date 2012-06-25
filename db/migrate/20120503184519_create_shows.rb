class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.datetime :date
      t.string :building
      t.string :address

      t.timestamps
    end
  end
end
