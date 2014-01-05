require 'spec_helper'

describe Article do
  it 'creates' do
    FactoryGirl.create(:article).should be_an_instance_of(Article)
  end

  it 'requires title to be unique' do
    FactoryGirl.create(:article)
    FactoryGirl.build(:article).should_not be_valid
  end

  it 'requires a title' do
    FactoryGirl.build(:article, :title => nil).should_not be_valid
  end

  it 'requires content' do
    FactoryGirl.build(:article, :content => nil).should_not be_valid
  end
end
