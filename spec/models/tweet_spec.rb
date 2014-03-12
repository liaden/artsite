require 'spec_helper'

describe Tweet do
  it 'creates' do
    FactoryGirl.create(:tweet)
  end

  it 'requires twitter id' do
    FactoryGirl.build(:tweet, :twitter_id => nil).should_not be_valid
  end

  it 'requires html' do
    FactoryGirl.build(:tweet, :html => nil).should_not be_valid
  end

  it 'requires a unique twitter id' do
    tweet = FactoryGirl.create(:tweet)
    FactoryGirl.build(:tweet, :twitter_id => tweet.twitter_id).should_not be_valid
  end
end
