require 'spec_helper'

describe Tag do
    it "can be instaniated" do
        Tag.new.should be_an_instance_of(Tag)
    end

    it "can create with name" do
        FactoryGirl.create(:tag).should be_persisted
    end

    it "fails without name" do
        FactoryGirl.build(:tag, :name => nil).should_not be_valid
    end

    it "can have spaces" do
        tag_name = "This is a test tag"
        tag = FactoryGirl.create(:tag, :name => tag_name )
        tag.should be_persisted
        tag.name.size.should  eql(tag_name.size)
    end

    it "trims leading space" do
        tag = FactoryGirl.create(:tag, :name => "   Emer")
        tag.name.should_not have_leading_spaces
    end

    it "trims trailing space"  do
        tag = FactoryGirl.create(:tag, :name => "Emer   ")
        tag.name.should_not have_trailing_spaces
    end

    it "should be unique by name" do
        tag1 = FactoryGirl.create(:tag, :name => "unique")
        tag2 = FactoryGirl.build(:tag, :name => "unique")
        tag2.should_not be_valid

    end

end
