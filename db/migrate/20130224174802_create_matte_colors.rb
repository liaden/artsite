class CreateMatteColors < ActiveRecord::Migration
  def change
    create_table :matte_colors do |t|
      t.string :color
      t.string :image_file_name
      t.string :image_content_type 
      t.string :image_file_size
    end
  end
end
