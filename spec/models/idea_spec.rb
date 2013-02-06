require 'spec_helper'

describe Idea do

    it "creates with valid data" do
        FactoryGirl.create(:idea).should be_persisted
    end

    it "fails without a description" do
        FactoryGirl.build(:idea, :description => nil).should_not be_valid
    end

    it "fails when description is an empty string" do
        FactoryGirl.build(:idea, :description => "").should_not be_valid
    end

    it "is by someone" do
        FactoryGirl.build(:idea, :by => nil).should_not be_valid
        FactoryGirl.build(:idea, :by => "").should_not be_valid
    end


    it "has a reference" do
        FactoryGirl.build(:idea, :reference => nil).should_not be_valid
        FactoryGirl.build(:idea, :reference => "").should_not be_valid
    end
end
