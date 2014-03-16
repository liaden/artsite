require 'spec_helper'

describe ArtworksController do
  let(:artwork) { FactoryGirl.create(:artwork) }
  let(:tagged_artwork) { FactoryGirl.create(:tagged_artwork) }
  let(:artwork_in_medium) { FactoryGirl.create(:artwork_in_medium) }

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
      it "shows featured artworks" do
        artwork.update_attributes :featured => true

        get :index
        assigns[:artworks].should_not be_empty
      end

      it "does not show unfeatured artworks" do
        artwork.update_attributes :featured => false

        get :index
        assigns[:artworks].should be_empty
      end
    end

    describe "GET filter" do
      context 'renders views' do
        render_views

        it "renders views without errors with no artworks" do
          expect { 
            get :filter_by_category, :category => '2004'
          }.to_not raise_error

          assigns[:artworks].should be_empty
        end
      end

      context 'finds by' do
        after(:each) { assigns[:artworks].should have(1).item }
      
        it "year" do
          FactoryGirl.create(:artwork, :created_at => DateTime.new(2012, 1, 5))
          get :filter_by_category, :category => '2012'
        end

        it "tag" do
          FactoryGirl.create(:tagged_artwork)
          get :filter_by_category, :category => Tag.first.name
        end

        it "fanart" do
          FactoryGirl.create(:artwork, :fanart => true) 
          get :filter_by_category, :category => 'Fanart'
        end
      end
    end
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

      it "does not create duplicate tags" do
        FactoryGirl.create(:tag, :name => 'big')
        FactoryGirl.create(:tag, :name => 'dancing')

        expect {
          post :create, @attrs
        }.to change{Tag.count}.by(1)
      end
      
      it "rolls back all changes on error" do
        art_count = Artwork.count
        tag_count = Tag.count
        medium_count = Medium.count

        expect {
          post :create, @attrs.merge(:artwork => {:title => nil})
        }.to raise_error(ActiveRecord::RecordInvalid)

        Artwork.count.should == art_count
        Tag.count.should == tag_count.should
        Medium.count.should == medium_count
      end

      it "redirects to new prints page on success" do
        post :create, @attrs
        response.should redirect_to( artwork_prints_path(Artwork.last))
      end
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
