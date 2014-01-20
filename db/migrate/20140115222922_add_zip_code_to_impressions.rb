class AddZipCodeToImpressions < ActiveRecord::Migration
  def change
    add_column :impressions, :latitude, :decimal, {:precision => 10, :scale => 6}
    add_column :impressions, :longitude, :decimal, {:precision => 10, :scale => 6}
  end
end
