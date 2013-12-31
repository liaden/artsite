class CreateRecommendedMattes < ActiveRecord::Migration
  def change
    create_table :recommended_matte_colors do |t|
      t.integer :artwork_id
      t.integer :matte_color_id
    end
  end
end
