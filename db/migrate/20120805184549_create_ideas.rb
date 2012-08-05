class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.text :description
      t.string :by
      t.string :reference

      t.timestamps
    end
  end
end
