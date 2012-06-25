class CreateAutoTumbles < ActiveRecord::Migration
  def change
    create_table :auto_tumbles do |t|
      t.integer :tumble_id

      t.timestamps
    end
  end
end
