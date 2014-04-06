require 'spec_helper'

describe Page do
  it 'creates' do
    FactoryGirl.create(:page).should be_an_instance_of(Page)
  end

  it 'requires name to be unique' do
    FactoryGirl.create(:page)
    FactoryGirl.build(:page).should_not be_valid
  end

  it 'requires a title' do
    FactoryGirl.build(:page, :name => nil).should_not be_valid
  end

  it 'requires content' do
    FactoryGirl.build(:page, :content => nil).should_not be_valid
  end

  it 'requires a page_type' do
    FactoryGirl.build(:page, :page_type => nil).should_not be_valid
  end

  it 'requires a specific page_type' do
    FactoryGirl.build(:page, :page_type => 'abcd').should_not be_valid
  end
end
