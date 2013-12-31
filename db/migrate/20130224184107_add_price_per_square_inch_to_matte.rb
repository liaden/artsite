class AddPricePerSquareInchToMatte < ActiveRecord::Migration
  def change
    add_column :matte_colors, :price_per_square_inch, :decimal

  end
end
