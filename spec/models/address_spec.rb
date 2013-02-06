require 'spec_helper'

describe Address do
    it "creates with valid data" do
        FactoryGirl.create(:address).should be_valid
    end

    it "is invalid without recipient" do
        FactoryGirl.build(:address, :recipient => nil).should_not be_valid
    end

    it "is invalid without line1" do
        FactoryGirl.build(:address, :line1 => nil).should_not be_valid
    end

    it "may have line2" do
        FactoryGirl.build(:address, :line2 => nil).should be_valid
    end
        
    it "is invalid without zipcode" do
        FactoryGirl.build(:address, :zipcode => nil).should_not be_valid
    end

    it "is invalid without city" do
        FactoryGirl.build(:address, :city => nil).should_not be_valid
    end
    it "is invalid without state" do
        FactoryGirl.build(:address, :state => nil).should_not be_valid
    end
end
