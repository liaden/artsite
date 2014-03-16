require 'spec_helper'

describe "Manage Artworks" do
  include BestInPlace::TestHelpers

  before(:each) { FactoryGirl.create(:show) } 
  let(:artwork) { FactoryGirl.create(:artwork, :featured => true) }

  before(:each) do
    FactoryGirl.create(:print, :artwork => artwork)
    FactoryGirl.create(:original, :artwork => artwork)
    FactoryGirl.create(:canvas, :artwork => artwork)
  end

  describe "view gallery" do
    it "shows the filters" do
      visit artworks_path

      within('#gallery-filters') do
        page.should have_content(Date.today.year.to_s)
        page.should have_content('Featured')
        page.should have_content('Fanart')
        page.should have_content('All')
      end
    end

    it "is showing the artwork thumbnails" do
      visit artworks_path
      find('img.th')[:src].should == artwork.image.url(:thumbnail)
    end

    it "can filter by tag" do
      tag = FactoryGirl.create(:tag, :artworks => [artwork])
      visit artworks_by_category_path(tag.name)
      page.should have_css('img.th')
    end

    it "does not show the admin widget" do
      visit artworks_path
      page.should_not have_css('.artwork-admin-controls')
    end
  end

  describe "viewing artwork" do
    it "has open graph tags" do
      visit artwork_path(artwork)
      page.should have_facebook_metatags
    end

    it "has the facebook like button"  do
      visit artwork_path(artwork)
      page.should
    end

    it "has fullsized artwork" do
      visit artwork_path(artwork)
      find('#artwork-image')[:src].should == artwork.image.url
    end

    it "does not show the edit button" do
      visit artwork_path(artwork)
      page.should_not have_content('Edit')
    end

    it "does not activate best in place"  do
      page.should_not have_css('.best_in_place')
    end

    it "shows all three purchase categories" 
    it "has all sizes listed for purchase"
    it "shows soldout for the original" 
  end

  context 'as admin' do
    before(:each) { login_step :admin }
    let(:upload_image) { 'spec/images/watercolor.png' }
    let(:default_attrs) do
        { :title => 'new title', :description => 'tada', :image => upload_image, :tags => 'a,b,c,d', :mediums => 'oil,watercolor pastel', :created => Date.today } 
    end

    def new_artwork_workflow attrs 
      visit new_artwork_path
    
      fill_in 'artwork_title', :with => attrs[:title]
      fill_in 'artwork_description', :with => attrs[:description]
      fill_in 'artwork_created_at', :with => attrs[:created].strftime('%m/%d/%Y')

      attach_file 'artwork_image',  attrs[:image] 

      fill_in :tags, :with => attrs[:tags] 
      fill_in :mediums, :with =>  attrs[:mediums ] 
  
      click_button 'Finish'
    end

    describe "viewing the gallery" do
      it "shows the admin settings widget" do
        visit artworks_path
        page.should have_css('.artwork-admin-controls')
      end
    end

    describe "viewing the artwork" do
      describe "with best in place", :js => true do
        before(:each) { visit artwork_path(artwork) }
        
        it "can edit the creation date" do
          id = "best_in_place_artwork_#{artwork.id}_created"

          page.execute_script <<-JS
            $("##{id}").click()
            $("#ui-state-default").click()
          JS

          artwork.created_at.should_not == artwork.reload.created_at
        end

        it "can edit the title" do
          bip_text artwork, :title, 'DIFFERENT'
          page.should have_content('DIFFERENT')
        end

        it "can edit the description" do
          bip_text artwork, :description, 'DIFFERENT'
          page.should have_content('DIFFERENT')
        end

        it "can toggle being featured" do
          bip_bool artwork, :featured
          page.should have_content('unfeatured')
        end
      end
    end

    describe "creating artwork" do
      it "gives positive feedback" do
        new_artwork_workflow default_attrs

        within('#flash-notice') do
          page.should have_content('successfully created')
        end
      end

      it "allows for setting creation date" do
        new_artwork_workflow default_attrs.merge(:created => Date.today - 7)

        Artwork.last.created_at.should < Date.today
      end

      it "moves to print creation step on success" do
        new_artwork_workflow default_attrs

        page.should have_content('add canvas')
        page.should have_content('add photopaper')
        page.should have_content('add original')
      end

      it "reports validation errors" do
        visit new_artwork_path
        click_button 'Finish'

        page.should have_css('div#form-error')
      end
    end

    describe "editing artwork" do
      before(:each) do
        visit artwork_path(artwork)
        click_link 'Edit'
      end

      it "shows the artwork after editing" do
        fill_in 'artwork_title', :with => 'DIFFERENT'
        click_button 'Finish'
        
        page.should have_content('DIFFERENT')
      end

      it "shows confirmation the artwork is edited" do
        click_button 'Finish'

        page.should have_content('has been successfully updated')
      end

      it "shows edit related prints link" do
        click_link 'Edit purchasing options'
        page.should have_content('add canvas')
      end
    end
  end
end
