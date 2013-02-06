require 'spec_helper'

describe MainController do

    describe "GET index" do
        it "should assign @artworks" do
            FactoryGirl.create(:artwork)

            get :index
            assigns(:artworks).first.should be_an_instance_of(Artwork)
        end

        it "should have empty list with no art" do
            get :index
            assigns(:artworks).should be_empty
        end

        it "should get at most five artworks" do
            1.upto(10) do 
                FactoryGirl.create(:artwork)
            end

            get :index

            assigns(:artworks).size.should eq(MainController::MOST_RECENT_LIMIT)
        end

    end
end

