
require 'spec_helper'

describe ShowsController do
    before(:each) do
        @show = FactoryGirl.create(:show)
    end

    context "as admin" do
        before(:each) { login :admin }

        context "GET #new" do
            it "assigns @show" do
                get :new
                assigns(:show).should be_an_instance_of(Show)
            end
        end

        context "GET #show" do
            it "assigns @show" do
                get :show, :id => @show.id
                assigns(:show).should be_an_instance_of(Show)
            end
        end

        context "POST #create" do
            it "creates a new show" do
                expect { post :create, :show => FactoryGirl.attributes_for(:show) }.to change{Show.count}.by(1)
            end

            it "redirects back to #new" do
                post :create, FactoryGirl.attributes_for(:show)
                response.code.should == "302"
            end
        end

        context "GET #edit" do
            it "assigns @show" do
                get :edit, :id => @show.id
                assigns(:show).should be_an_instance_of(Show)
            end
        end

        context "POST #update" do
            it "updates the name" do
                post :update, :id => @show.id, :show => {:name => "herp derp"}
                @show.reload.name.should == "herp derp"
            end

            it "shows the updated show" do
                post :update, :id => @show.id, :show => FactoryGirl.attributes_for(:show)

                assigns(:show).id.should == @show.id
            end

        end
    end

    context "as guest" do
        context "GET #new" do
            it "redirects" do
                get :new
                response.code.should == "302"
            end
        end

        context "GET #show" do
            it "assigns @show" do
                get :show, :id => @show.id
                assigns(:show).id.should == @show.id
            end
        end

        context "POST #create" do
            it "redirects" do
                post :create
                response.code.should == "302"
            end

            it "does not create the show" do
                expect { post :create, FactoryGirl.attributes_for(:show) }.to_not change { Show.count }
            end
        end

        context "GET #edit" do
            it "redirects" 
        end

        context "POST #update" do
            it "redirects"
            it "does not update the show"
        end
    end

end
