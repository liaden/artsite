require 'spec_helper'

describe InventoryController do
    before(:each) do
        @print = FactoryGirl.create(:print)
        @canvas = FactoryGirl.create(:print, :material => 'canvas')
    end

    context "as admin" do
        before(:each) do 
            activate_authlogic
            @user = FactoryGirl.create(:admin)
            UserSession.create(@user)
        end

        describe "GET #index" do
            it "sets @artworks" do
                get :index

                assigns(:artworks).should_not be_empty
            end
        end

        describe "GET #edit" do
            it "sets @artwork" do
                get :edit, :id => @print.artwork.id

                assigns(:artwork).should be_an_instance_of(Artwork)
            end
        end

        describe "POST #update" do
            it "updates prices"  do
                old_count = @canvas.inventory_count
                post :update, "#{@canvas.material}_#{@canvas.size_name}_count" => @canvas.inventory_count + 1, :id => @canvas.artwork.id

                @canvas.reload.inventory_count.should == old_count + 1
            end

            it "does not allow for negatives counts" do
                post :update, "#{@print.material}_#{@print.size_name}_count" => -1, :id => @print.artwork.id

                @print.reload.inventory_count.should_not == -1
            end
        end

    end 

    context "as visitor" do
        describe "GET #index" do
            it "redirects" do
                get :index

                response.code.should == "302"
            end
        end

        describe "GET #edit" do
            it "redirects" do
                get :edit, :id => @print.artwork.id

                response.code.should == '302'
            end
        end

        describe "POST #update" do
            it "redirects" do 
               post :update, :id => @print.artwork.id

               response.code.should == "302"
            end

            it "does not change prices" do
                old_count = @print.inventory_count
                post :update, "#{@print.material}_#{@print.size_name}_count" => @print.inventory_count + 1, :id => @print.artwork.id

                @print.reload.inventory_count.should == old_count
            end
        end
    end
end
