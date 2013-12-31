require 'spec_helper'

describe RecommendedMatteColor do
    before(:each) { mock_paperclip_post_process }

    it "can be created" do
        FactoryGirl.create(:recommended_matte_color).should be_an_instance_of(RecommendedMatteColor)
    end

    it "requires an artwork and it requires a matte_color" do
        recommendation = FactoryGirl.build(:recommended_matte_color, :artwork => nil, :matte_color => nil)
        recommendation.invalid?.should be_true
        recommendation.errors.count.should == 2
    end

end
