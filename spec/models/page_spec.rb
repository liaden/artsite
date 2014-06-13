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
  describe 'videos' do
    let(:video) { FactoryGirl.build(:video) }
    it 'requires the video pull from youtube' do
      FactoryGirl.build(:video, :content => 'Not linking to video stuff').should_not be_valid
    end

    it 'creates' do
      video.save! 
      video.should be_an_instance_of(Page)
    end

    it 'identifies as a page' do
      video.should be_video
    end      

    it 'is not a tutorial' do
      video.should_not be_tutorial
    end
  end

  describe 'tutorial' do
    let(:tutorial) { FactoryGirl.build(:tutorial) }

    it 'identifies as a tutorial' do
      tutorial.should be_tutorial
    end

    it 'is not a video' do
      tutorial.should_not be_video
    end
  end
end
