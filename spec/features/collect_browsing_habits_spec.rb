require 'spec_helper'

describe 'collect browsing habits' do
  let(:artwork) { FactoryGirl.create(:artwork) }
  before(:each) do
    @artwork = artwork
    @show = FactoryGirl.create(:show)
  end

  context 'as admin' do 
    before(:each)  { login_step :admin }

    it 'does not track artworks' do
      visit artwork_path(artwork)
      Impression.all.should be_empty
    end
  end

  context 'as user' do
    before(:each) { login_step :user }

    it 'stores user id' do
      visit artwork_path(artwork)
      Impression.first.user.should_not be_nil

      Impression.guest_impressions.should be_empty
      Impression.user_impressions.should_not be_empty
    end
  end

  context 'as guest' do
    it 'tracks views of artworks' do 
      visit artwork_path(artwork)

      Impression.artwork_impressions.should_not be_empty
    end

    it 'does not have a user id' do
      visit artwork_path(artwork)

      Impression.first.user.should be_nil

      Impression.guest_impressions.should_not be_empty
      Impression.user_impressions.should be_empty
    end

  end
end
