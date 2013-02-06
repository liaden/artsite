require 'spec_helper'

describe Commission do
    it "requires an email" do
        FactoryGirl.build(:commission, :email => nil).should_not be_valid
    end

    it "requires a customer" do
        FactoryGirl.build(:commission, :customer => nil).should_not be_valid
    end

    it "requires comments" do
        FactoryGirl.build(:commission, :comments => nil).should_not be_valid
    end
end
