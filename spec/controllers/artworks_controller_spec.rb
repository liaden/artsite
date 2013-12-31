require 'spec_helper'

describe ArtworksController do
    let(:artwork) { FactoryGirl.create(:artwork) }
    let(:tagged_artwork) { FactoryGirl.create(:tagged_artwork) }
    let(:artwork_in_medium) { FactoryGirl.create(:artwork_in_medium) }

    before(:each) { mock_paperclip_post_process }

    before(:each) do

        @containing_folder = './spec/images/'
        @watercolor = "#{@containing_folder}watercolor.png"
        @create = "#{@containing_folder}create.jpg"
        @rails = "#{@containing_folder}rails.png"

        DefaultPrice.add_test_defaults_to_database
    end

    context "as a guest" do
        let(:item) { artwork }
        let(:redirect_url) { artworks_path }
        let(:attrs) { FactoryGirl.attributes_for(:artwork) }
        let(:table) { Artwork }

        it_behaves_like 'unauthorized GET new'
        it_behaves_like 'unauthorized POST create'
        it_behaves_like 'unauthorized GET edit'
        it_behaves_like 'unauthorized DELETE destroy'

        describe "GET index" do
            it "assigns @artworks" do
                artwork

                get :index
                assigns[:artworks].should_not be_empty
            end
        end

        #describe "GET new" do
        #    it "redirects" do
        #        get :new
        #        response.should redirect_to(artworks_path)
        #    end
        #end

        #describe "POST create" do
        #    it "redirects" do
        #        expect { post :create
        #               }.to change { Artwork.count }.by(0)

        #        response.should redirect_to(artworks_path) 
        #    end

        #    it "does not create a new artwork" do
        #        expect { post :create }.to change { Artwork.count }.by(0)
        #   end

        #end

        #describe "GET edit" do
        #    it "redirects" do
        #        get :edit, :id => artwork.id
        #        response.should redirect_to(artworks_path)
        #    end
        #end

        #describe "PUT update" do
        #    it "redirects" do
        #        put :update, :id => artwork.id, :artwork => { :title => 'DIFFERENT' }
        #        response.should redirect_to(artworks_path)
        #    end

        #    it "does not update teh artwork" do
        #        put :update, :id => artwork.id, :artwork => { :title => 'DIFFERENT' }
        #        artwork.reload.title.should_not eq('DIFFERENT')
        #    end
        #end
    end

    context "as an admin" do
        before(:each) { login :admin }

        describe "GET new" do
            it "assigns artwork" do
                get :new
                assigns(:artwork).should be_an_instance_of(Artwork)
            end
        end

        describe "POST create" do
            before(:each) do
                @attrs = { :artwork => FactoryGirl.attributes_for(:artwork, :image => Rack::Test::UploadedFile.new(@rails)),
                           :tags => "big,buterflies,dancing",
                           :mediums => "watercolor",
                         }
            end

            it "saves a new artwork" do
                expect {
                    post :create, @attrs
                }.to change {Artwork.count }.by(1)
            end

            #it "saves with only the original prints" do
            #    expect {
            #        post :create, @attrs
            #    }.to change { Print.count }.by(1)
            #end

            #it "saves only one in the small size" do
            #    @attrs[:enable_s] = "yes"

            #    expect {
            #        post :create, @attrs
            #    }.to change { Print.count }.by(2)
            #end

            #it "saves 8 prints with all options selected"  do
            #    expect {
            #        post :create, @attrs
            #    }.to change { Print.count }.by(8)
            #
            #end

            #it "saves with the original already sold out"  do
            #    @attrs[:is_sold_out] = "yes"
            #
            #    post :create, @attrs
            #    artwork = Artwork.last
            #
            #    artwork.original.is_sold_out.should == true
            #end

            #it "does not create an artwork given a bad size" do
            #    @attrs[:original_size] = "not a valid size"

            #    expect {
            #        post :create, @attrs
            #    }.to_not change { Artwork.count }
            #end

            #it "does not create any prints given a bad size" do
            #    expect { 
            #        @attrs[:original_size] = "not a valid size"
            #        post :create, @attrs
            #    }.to_not change { Artwork.count }
            #end


        end

        describe "GET edit" do

            it "sets the artwork" do
                get :edit, :id => artwork.id
                assigns[:artwork].should == artwork
            end

            it "sets csv tags" do
                get :edit, :id => tagged_artwork.id
                assigns[:tags].should_not be_empty
            end
            it "sets csv mediums" do
                get :edit, :id => artwork_in_medium.id
                assigns[:medium].should_not be_empty
            end

        end

        describe "PUT update" do
            it "updates the attributes" do
                post :update, :id => artwork.id, :artwork => { :title => 'DIFFERENT' }
                artwork.reload.title.should == 'DIFFERENT'
            end

            it "updates new tags" do
                post :update, :id => artwork.id, :artwork => {}, :tags => 'x,y,z'
                sorted_tag_names = artwork.tags.map(&:name).sort 
                
                sorted_tag_names.should == ['x', 'y', 'z']
            end

        end

        describe "POST destroy" do

            it "destroys the artwork" do
                artwork
                expect { post :destroy, :id => artwork.id }.to change{Artwork.count}.by(-1)
            end

            it "destroys associated prints" do
                artwork
                expect { post :destroy, :id => artwork.id }.to change{Print.count}.by(-1*artwork.prints.count)
            end
        end
    end

end
