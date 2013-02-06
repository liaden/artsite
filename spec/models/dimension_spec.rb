require 'spec_helper'

describe Dimension do
    it "constructs with valid data" do
        FactoryGirl.create(:dimension).should be_persisted
    end

    it "is invalid with nil width" do
        FactoryGirl.build(:dimension, :width => nil).should_not be_valid
    end

    it "is invalid with nil height" do
        FactoryGirl.build(:dimension, :height => nil).should_not be_valid
    end

    it "is invalid given negative width" do
        FactoryGirl.build(:dimension, :width => -2).should_not be_valid
    end

    it "is invalid given negative height" do
        FactoryGirl.build(:dimension, :width => -8).should_not be_valid
    end

    
    it "is invalid given 0 width" do
        FactoryGirl.build(:dimension, :width => 0).should_not be_valid
    end

    it "is invalid given 0 height" do
        FactoryGirl.build(:dimension, :width => 0).should_not be_valid
    end

    it "converts to string" do
        d = FactoryGirl.build(:dimension, :width => 5, :height => 7)
        d.to_s.should eql("5x7")
    end

    it "gets height from string" do
        dimension = FactoryGirl.create(:dimension, :width => 5, :height => 5)
        dimension.parse_dimensions(dimension.to_s)[:height].should eq(dimension.height)
    end

    it "gets width from string" do
        dimension = FactoryGirl.create(:dimension, :width => 5, :height => 5)
        dimension.parse_dimensions(dimension.to_s)[:width].should eq(dimension.width)
    end

    it "creates from string" do
        Dimension.create_from_str("5x7").should be_valid
    end

end
