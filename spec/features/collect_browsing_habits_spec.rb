require 'spec_helper'

describe 'collect browsing habits' do
  before(:each) { mock_paperclip_post_process }

  let(:artwork) { FactoryGirl.create(:artwork) }

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

    # test fails when internet connection is slow
    it 'looks up lat long from ip_address' do
      visit artwork_path(artwork)

      impression = Impression.first

      # set ip address this way instead of trying to spoof it for testing
      impression.update_attributes(:ip_address => ip_addresses(:hsv))

      impression.latitude.should > 34
      impression.longitude.should < -86
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
