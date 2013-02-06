require 'spec_helper'

describe Medium do
    it "can be instaniated" do
        Medium.new.should be_an_instance_of(Medium)
    end

    it "can create with name" do
        FactoryGirl.create(:medium ).should be_persisted
    end

    it "fails without name" do
        FactoryGirl.build(:medium, :name => nil).should_not be_valid
        FactoryGirl.build(:medium, :name => "").should_not be_valid
    end

    it "trims trailing spaces" do
        medium = FactoryGirl.create(:medium, :name => "watercolor   ")
        medium.name.should_not have_trailing_spaces
    end

    it "trims leading spaces" do
        medium = FactoryGirl.create(:medium, :name => "   watercolor")
        medium.name.should_not have_leading_spaces
    end

    it "can have spaces" do
        FactoryGirl.create(:medium, :name => "water color").should_not
    end

    it "should be unique by name" do
        medium1 = FactoryGirl.create(:medium, :name => "unique")
        medium2 = FactoryGirl.build(:medium, :name => "unique")
        medium2.should_not be_valid
    end

end

