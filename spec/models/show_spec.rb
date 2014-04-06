require 'spec_helper'

describe Show do
  it "creates with valid data" do
    FactoryGirl.create(:show).should be_an_instance_of(Show)
  end

  it "fails without a date" do
    FactoryGirl.build(:show, :name => nil).should_not be_valid
  end

  it "fails without a name" do 
    FactoryGirl.build(:show, :name => nil).should_not be_valid
    FactoryGirl.build(:show, :name => "").should_not be_valid
  end

  it "may have a building" do
    FactoryGirl.create(:show, :building => nil).should be_persisted
    FactoryGirl.create(:show, :building => "").should be_persisted
  end

  it "fails without an address" do
    FactoryGirl.build(:show, :address => nil).should_not be_valid
    FactoryGirl.build(:show, :address => "").should_not be_valid
  end

  it "fails without a description" do
  FactoryGirl.build(:show, :description => nil).should_not be_valid
  FactoryGirl.build(:show, :description => "").should_not be_valid
  end

  it "can be different show_types" do
    Show.valid_show_types.each do |show_type|
      FactoryGirl.create(:show, :show_type => show_type).should be_persisted
    end
  end

  it "cannot be an invalid show" do
    FactoryGirl.build(:show, :show_type => "xyz").should_not be_valid
  end

  describe 'Show.upcoming' do
    it 'does not list already finished shows' do
      FactoryGirl.create( :show )
      FactoryGirl.create( :show, :date => 7.days.ago )

      Show.upcoming.should have(1).item
    end

    it 'does not order by creation date' do
      second_id = FactoryGirl.create(:show, :date => 8.days.from_now).id
      third_id = FactoryGirl.create(:show, :date => 9.days.from_now).id
      first_id = FactoryGirl.create(:show, :date => 7.days.from_now).id

      Show.upcoming.map(&:id).should == [ first_id, second_id, third_id ]
    end
  end
end

