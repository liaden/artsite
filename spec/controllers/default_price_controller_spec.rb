require 'spec_helper'

describe DefaultPriceController do
    context "as admin" do
        before(:each) { login :admin }

        describe "GET #edit" do

            it "renders the #edit view" do
                get :edit
                response.should render_template :edit
            end

            it "assigns canvas prints" do
                default_canvas = FactoryGirl.create(:default_price, :material => 'canvas')
                get :edit
                assigns(:canvases).should eq( [default_canvas] )
            end

            it "assigns regular prints" do
                default_print  = FactoryGirl.create(:default_price, :material => 'photopaper')
                get :edit
                assigns(:photopapers).should eq( [default_print] )
            end
        end

        describe "POST #update" do
            before(:each) do
                @default_price = FactoryGirl.create(:default_price)
            end

            context "with valid data" do
                it "renders the #update view"  do 
                    post :edit, @default_price.id.to_s => "50"

                    response.should render_template :edit
                end

                it "updates the price" 

                it "updates the price of prints" 
            end

            context "with invalid data:" do
                it "default price does not exist" do
                    post :update, (@default_price.id+1).to_s => "50"

                    flash[:error].should_not be_nil
                end

                it "has a non-numeric price" do
                    post :update, @default_price.id.to_s => "abcda"
                end

                it "has a negative price" do
                    post :update, @default_price.id.to_s => "-5"
                end
            end
        end
    end

    context "as visitor" do
        describe "GET #edit" do
            it "redirects" do
                get :edit

                response.code.should == "302"
            end
        end
    end
end
