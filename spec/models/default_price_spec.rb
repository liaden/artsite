require 'spec_helper'

describe DefaultPrice do
    it "creates with valid data" do
        FactoryGirl.create(:default_price).should be_valid
    end

    context "requires a price" do
        it "cannot be nil" do  
            FactoryGirl.build(:default_price, :price => nil).should_not be_valid 
        end

        it "cannot be 0" do
            FactoryGirl.build(:default_price, :price => 0).should_not be_valid 
        end

        it "cannot be negative" do 
            FactoryGirl.build(:default_price, :price => -5).should_not be_valid
        end
    end

    context "requires a material" do
    end

end
