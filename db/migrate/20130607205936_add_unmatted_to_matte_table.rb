class AddUnmattedToMatteTable < ActiveRecord::Migration
  def  up
    Matte.create :size => 0, :matte_color => nil
  end
  def down
  end
end
