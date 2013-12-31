require 'spec_helper'

describe MediumController do
    before(:each) { mock_paperclip_post_process }

    describe "GET show" do
        before(:each) do
            @mediums = [ FactoryGirl.create(:medium), FactoryGirl.create(:medium), FactoryGirl.create(:medium) ]
            @artwork_all_mediums =  FactoryGirl.create(:artwork, :medium => @mediums )
            @artwork_two_mediums = FactoryGirl.create(:artwork, :medium => [@mediums[0], @mediums[1]])
        end

        it "assigns @medium" do
            get :show, :id =>  @mediums[0]
            assigns(:media).should be_an_instance_of(Medium)
        end


        it "assigns @artworks" do
            get :show, :id => @mediums[0]
            assigns(:artworks).should_not be_empty
        end

        it "gets correct artworks" do
            get :show, :id => @mediums[2]
            assigns(:artworks).size.should eq(1)
        end

    end
end

