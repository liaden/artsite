require 'spec_helper'

describe ArtworksController do
    before(:each) do
        @artwork = FactoryGirl.create(:artwork)

        @containing_folder = './spec/images/'
        @watercolor = "#{@containing_folder}watercolor.png"
        @create = "#{@containing_folder}create.jpg"
        @rails = "#{@containing_folder}rails.png"

        DefaultPrice.add_test_defaults_to_database
    end

    context "as a visitor" do
        describe "GET index" do
            it "assigns @artworks" do
                get :index
                assigns(:artworks).should_not be_empty
            end
        end

        describe "GET new" do
            it "redirects" do
                get :new
                response.should redirect_to(artworks_path)
            end
        end

        describe "POST create" do
            it "redirects" do
                post :create
                response.should redirect_to(artworks_path)
            end
        end

        describe "GET edit" do
            it "redirects" do
                get :edit, :id => @artwork.id
                response.should redirect_to(artworks_path)
            end
        end

        describe "PUT update" do
            it "redirects" do
                put :update, :id => @artwork.id
                response.should redirect_to(artworks_path)
            end
        end
    end

    context "as an admin" do
        before(:each) do
            activate_authlogic
            @user = FactoryGirl.create(:admin)
            UserSession.create(@user)
        end

        describe "GET new" do
            it "assigns artwork" do
                get :new
                assigns(:artwork).should be_an_instance_of(Artwork)
            end
        end

        describe "POST create" do
            before(:each) do
                @starting_print_count = Print.all.size
                @starting_artwork_count = Artwork.all.size
                @attrs = { :artwork => FactoryGirl.attributes_for(:artwork, :image => Rack::Test::UploadedFile.new(@rails)),
                          :tags => "big,buterflies,dancing",
                          :mediums => "watercolor",
                          :original_size => "16x20",
                          :original_price => "800.00"
                        }
            end

            it "saves a new artwork" do
                post :create, @attrs
                Artwork.all.size.should == @starting_artwork_count + 1
            end

            it "saves with only the original prints" do

                post :create, @attrs
                @artwork = Artwork.last

                @artwork.prints.size.should == @starting_print_count + 1 
            end

            it "saves only one in the small size" do
                @attrs[:enable_s] = "yes"

                post :create, @attrs
                @artwork = Artwork.last

                # +2 for one for small, one for original
                @artwork.prints.size.should == @starting_print_count + 2
            end

            it "saves 8 prints with all options selected"  do
                @attrs[:enable_s] = "yes"
                @attrs[:enable_m] = "yes"
                @attrs[:enable_l] = "yes"
                @attrs[:enable_xl] = "yes"

                post :create, @attrs
                @artwork = Artwork.last

                @artwork.prints.size.should == @starting_print_count + 8
            end

            it "saves with the original already sold out"  do
                @attrs[:is_sold_out] = "yes"

                post :create, @attrs
                @artwork = Artwork.last

                @artwork.original.is_sold_out.should == true
            end

            it "does not create an artwork given a bad size" do
                @attrs[:original_size] = "not a valid size"
                post :create, @attrs
                Artwork.all.size.should == @starting_artwork_count
            end

            it "does not create any prints given a bad size" do
                @attrs[:original_size] = "not a valid size"
                post :create, @attrs
                Print.all.size.should == @starting_print_count
            end
        end

        describe "GET edit" do
            it "sets the artwork" do
                get :edit, :id => @artwork.id
                assigns(:artwork).should == @artwork
            end
        end

        describe "PUT update" do
        end
    end

end
