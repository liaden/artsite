require 'spec_helper'

describe Medium do
    it "can be instaniated" do
        Medium.new.should be_an_instance_of(Medium)
    end

    it "can create with name" do
        Medium.create(:name => "Test").should be_persisted
    end

    it "fails without name" do
        Medium.create.should_not be_persisted
    end
end

