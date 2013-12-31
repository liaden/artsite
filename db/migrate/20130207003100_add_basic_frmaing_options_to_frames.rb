class AddBasicFrmaingOptionsToFrames < ActiveRecord::Migration
  def change
      Frame.create! :thickness => 0, :depth => 0, :price_per_inch => 0, :linear_inches => 0
      Frame.create! :thickness => 2, :depth => 0.75, :price_per_inch => 0.2020, :linear_inches => 0
      Frame.create! :thickness => 1.25, :depth => 0.75, :price_per_inch => 0.1625, :linear_inches => 0
      Frame.create! :thickness => 0.75, :depth => 0.5, :price_per_inch => 0.0993, :linear_inches => 0
  end
end
