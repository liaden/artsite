require 'spec_helper'

describe TagsController do
    let(:tag) { FactoryGirl.create(:tag, :name => 'tag1') }
    let(:tags) {[ tag, FactoryGirl.create(:tag, :name => 'tag2'), FactoryGirl.create(:tag, :name => 'tag3') ] }

    context "as a guest" do
        describe "GET show" do
 
            before(:each) do
                @artwork_all_tags =  FactoryGirl.create(:artwork, :tags => tags )
                @artwork_two_tags = FactoryGirl.create(:artwork, :tags => [tags[0], tags[1]])
            end

            it "assigns @tag" do
                get :show, :id => tag
                assigns(:tag).should be_an_instance_of(Tag)
            end


            it "assigns @artworks" do
                get :show, :id => tag
                assigns(:artworks).should have(tag.artworks.count).items
            end

            it "gets correct artworks" do
                get :show, :id => tags.last
                assigns(:artworks).should have(1).items
            end
        end

        context 'redirects to home' do
            after(:each) { response.should redirect_to(home_path) }

            it "for index" do
                get :index
            end
            it "for destroy" do
                post :destroy, :id => tag.id
            end
            it "for update" do
                post :update, :id => tag.id, :name => 'blarr'
            end
            it "for edit" do
                get :edit, :id => tag.id
            end
            it "for clear_orphans" do
                post :clear_orphans 
            end
        end
    end

    context 'as admin' do
        before(:each) { login(:admin) }

        describe "GET index" do
            it "assigns all tags" do
                @tag = FactoryGirl.create :tag 
                get :index
                assigns[:tags].should have(1).items
                assigns[:tags].first.should be_an_instance_of(Tag)
            end
        end

        describe "GET edit" do
            before(:each) { @artwork = FactoryGirl.create( :artwork, :tags => [ tag ] ) }

            it "assigns tag and artworks" do
                get :edit, :id => tag.id 
                assigns[:tag].should == tag
                assigns[:artworks].should_not be_empty
            end
        end

        describe "PUT update" do
            it "updates the name" do
                put :update, :id => tag, :tag => { :name => 'new name' }
                tag.reload.name.should == 'new name'
            end
            it "merges if tag with name exists" do
                @t1 = FactoryGirl.create(:tagged_artwork).tags.first
                @t2 = FactoryGirl.create(:tagged_artwork).tags.first

                expect { put :update, :id => @t2, :tag => { :name => @t1.name }  }.to change{Tag.count}.by(-1)
                Tag.first.artworks.should have(2).items
            end
        end

        describe "POST clear_orphans" do
            before(:each) { @tag = FactoryGirl.create :tag }
            it "records number of records destroyed" do
                post :clear_orphans
                Tag.count.should == 0
            end

            it "destroys number of records claimed" do
               post :clear_orphans 
               assigns[:cleaned_up].should == 1 
            end

        end

        describe "POST destroy" do
            it "destroys the record" do
                @tag = tag # force create
                expect { post :destroy, :id => tag.id }.to change{ Tag.count }.by(-1)
            end

            it "does not destroy artwork" do
                @artwork = tag.artworks.first
                expect { post :destroy, :id => tag.id }.to_not change{ Artwork.count }
            end
                
        end
    end
end
