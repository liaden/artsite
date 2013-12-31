require 'spec_helper'

describe ArtworkMedium  do
    
    before(:each) { mock_paperclip_post_process }

    before(:each) do
    end

    it "creates with valid data" do
        FactoryGirl.create(:artwork_in_medium).should be_valid    
    end

end
