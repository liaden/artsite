require 'spec_helper'

describe TagsController do
    describe "GET show" do
        before(:each) do
            @tags = [ FactoryGirl.create(:tag), FactoryGirl.create(:tag), FactoryGirl.create(:tag) ]
            @artwork_all_tags =  FactoryGirl.create(:artwork, :tags => @tags )
            @artwork_two_tags = FactoryGirl.create(:artwork, :tags => [@tags[0], @tags[1]])
        end

        it "assigns @tag" do
            get :show, :id =>  @tags[0]
            assigns(:tag).should be_an_instance_of(Tag)
        end


        it "assigns @artworks" do
            get :show, :id => @tags[0]
            assigns(:artworks).should_not be_empty
        end

        it "gets correct artworks" do
            get :show, :id => @tags[2]
            assigns(:artworks).size.should eq(1)
        end

    end
end
