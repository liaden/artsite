require 'spec_helper'

describe InventoryController do
    let(:print) { FactoryGirl.create :print }
    let(:canvas) { FactoryGirl.create :canvas }

    context "as admin" do
        before(:each) { login :admin }

        describe "GET #index" do
            it "sets @artworks" do
                get :index

                assigns(:artworks).should have(Artwork.count).items
            end
        end

        describe "GET #edit" do
            it "sets @artwork" do
                get :edit, :id => print.artwork.id

                assigns(:artwork).should be_an_instance_of(Artwork)
            end
        end

        describe "POST #update" do
            it "updates prices"  do
                expect { post :update, "#{canvas.material}_#{canvas.size_name}_count" => canvas.inventory_count + 1, :id => canvas.artwork.id 
                  }.to change{ canvas.reload.inventory_count }.by(1)

            end

            it "does not allow for negatives counts" do
                post :update, "#{print.material}_#{print.size_name}_count" => -1, :id => print.artwork.id

                print.reload.inventory_count.should_not == -1
            end
        end

    end 

    context "as visitor" do
        let(:item) { print }
        let(:redirect_url) { home_path }
        let(:attrs) { { "#{print.material}_#{print.size_name}_count" => 0, :id => print.artwork.id } }
        it_behaves_like 'unauthorized GET index'
        it_behaves_like 'unauthorized GET edit'
        it_behaves_like 'unauthorized PUT update'

        #describe "GET #index" do
        #    it "redirects" do
        #        get :index

        #        response.code.should == "302"
        #    end
        #end

        #describe "GET #edit" do
        #    it "redirects" do
        #        get :edit, :id => @print.artwork.id

        #        response.code.should == '302'
        #    end
        #end

        #describe "POST #update" do
        #    it "redirects" do 
        #       post :update, :id => @print.artwork.id

        #       response.code.should == "302"
        #    end

        #    it "does not change prices" do
        #        old_count = @print.inventory_count
        #        post :update, "#{@print.material}_#{@print.size_name}_count" => @print.inventory_count + 1, :id => @print.artwork.id

        #        @print.reload.inventory_count.should == old_count
        #    end
        #end
    end
end
