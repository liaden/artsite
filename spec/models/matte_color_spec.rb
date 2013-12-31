require 'spec_helper'

describe MatteColor do
    it "requires an image, color, inventory count, and price per square inch" do
        matte = FactoryGirl.build :matte_color, :image => nil, :color => nil, :inventory_count => nil, :price_per_square_inch => nil

        matte.should_not be_valid

        matte.errors.count.should >= 4
    end

    it "requires inventory count to not be negative" do
        FactoryGirl.build(:matte_color, :inventory_count => -1).should_not be_valid
    end

    it "inventory count can be 0" do
        FactoryGirl.create(:matte_color, :inventory_count => 0).should be_an_instance_of(MatteColor)
    end

end

