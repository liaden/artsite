require 'spec_helper'

describe ScheduleController do

    describe "GET index" do
        it "should assign @shows" do
            get :index
            assigns(:shows).size.should eq(0)
        end

        it "should list only future shows" do
            FactoryGirl.create(:show, :date => 30.days.ago )
            FactoryGirl.create(:show, :date => 30.days.from_now )

            get :index
            assigns(:shows).should_not be_empty
        end
    end
end


