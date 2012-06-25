class CreateLessonOrders < ActiveRecord::Migration
  def change
    create_table :lesson_orders do |t|
      t.integer :lesson_id
      t.integer :order_id

      t.timestamps
    end
  end
end
