class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.datetime :date
      t.integer :free_spots
      t.text :description

      t.timestamps
    end
  end
end
