require 'spec_helper'

describe Tag do
    it "can be instaniated" do
        Tag.new.should be_an_instance_of(Tag)
    end

    it "can create with name" do
        Tag.create(:name => "Test").should be_persisted
    end

    it "fails without name" do
        Tag.create.should_not be_persisted
    end
end
