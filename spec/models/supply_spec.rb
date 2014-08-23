require 'spec_helper'

describe Supply do
  it 'creates' do
    FactoryGirl.create(:supply).should be_an_instance_of(Supply)
  end

  it 'requires a name' do
    FactoryGirl.build(:supply, :name => nil).should_not be_valid
  end

  it 'requires a category' do
    FactoryGirl.build(:supply, :category => nil).should_not be_valid
  end

  it 'requires a referral url' do
    FactoryGirl.build(:supply, :referral_url => nil).should_not be_valid
  end

  it 'requires a predefined category' do
    FactoryGirl.build(:supply, :category => 'abcd').should_not be_valid
  end

  it 'requires a description' do
    FactoryGirl.build(:supply, :description => nil).should_not be_valid
  end

  it 'requires a short description' do
    FactoryGirl.build(:supply, :short_description => nil).should_not be_valid
  end

  describe 'verify_url' do
    it 'true with 200 status' do
      FactoryGirl.build(:supply).verify_url.should be true
    end

    it 'false if not 200 status code' do
      supply = FactoryGirl.build(:supply)
      supply.referral_url += 'aaaaaaaaaaaaa'
      supply.verify_url.should be false
    end

    it 'false on error' do
      supply = FactoryGirl.build(:supply, :referral_url => 'http://abcd')
      supply.verify_url.should be false
    end
  end
end
