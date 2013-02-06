require 'spec_helper'

describe CommissionsController do
    context "GET #new" do
        it "assigns @commission" do
            get :new
            assigns(:commission).should_not be_nil
        end
    end

    context "POST #create" do
        it "creates a new commission" do
            post :create, :commission => FactoryGirl.attributes_for(:commission)

            Commission.first.should_not be_nil
        end

        it "with invalid attributes" do
            post :create, :comission => FactoryGirl.attributes_for(:commission, :email => nil)

            flash[:error].size.should_not == 0
        end

        it "redirects" do
            post :create, :commission => FactoryGirl.attributes_for(:commission)

            response.code.should == "302"
        end

        it "sends an email"
    end

end
