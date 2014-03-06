require 'spec_helper'

describe "Manage Artworks" do
    before(:each) { mock_paperclip_post_process }

    let(:artwork) { FactoryGirl.create(:artwork) }

    before(:each) do
        FactoryGirl.create(:print, :artwork => artwork)
        FactoryGirl.create(:original, :artwork => artwork)
        FactoryGirl.create(:canvas, :artwork => artwork)
    end

    describe "view gallery" do
        it "has the navbar/footer" do
            visit artworks_path
            check_footer_header page
        end
        
        it "shows the tags and mediums" do
            visit artworks_path
            within("#mediums") do
                artwork.medium.each { |medium| page.should have_content(medium.name) }
            end

            within("#tags") do
                artwork.tags.each { |tag| page.should have_content(tag.name) }
            end
        end
    end

    describe "viewing artwork" do
        it "has open graph tags" do
            visit artwork_path(artwork)
            page.should have_facebook_metatags
        end

       it "has the navbar/footer" do
            visit artworks_path
            check_footer_header page
        end

        it "has the facebook like button"  do
            visit artwork_path(artwork)
            page.should
        end

        it "has fullsized artwork" do
            visit artwork_path(artwork)
            find('#artwork_image')[:src].should == artwork.image.url
        end

        it "has only these tags and mediums" do
            missing_tag = FactoryGirl.create(:tag, :name => 'tada', :artworks => [ FactoryGirl.create(:artwork) ] )
            missing_medium = FactoryGirl.create(:medium, :name => 'herpaderpa', :artworks => missing_tag.artworks )

            visit artwork_path(artwork)
            within('#tags') do
                page.should_not have_content(missing_tag.name) 
            end

            within('#mediums') do
                page.should_not have_content(missing_medium.name) 
            end
        end

        it "shows all three purchase categories" 
        it "has all sizes listed for purchase"
        it "shows soldout for the original" 
        #    artwork.prints.original.update_attributes :is_sold_out => true

        #    visit artwork_path(artwork)
        #    within('#original') do
        #        page.should have_content("Sold")
        #        page.should_not have_selector("input[type='submit']")
        #    end
        #end

        it "has all the framing options"
        it "computes the total"
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

                page.should have_content('new canvas')
                page.should have_content('new photopaper')
                page.should have_content('Add original')
            end

            it "reports validation errors" do
                visit new_artwork_path
                click_button 'Finish'

                page.should have_css('div#model-errors')
            end
        end

        describe "editing artwork" do

            it "does not create duplicate tags or mediums" do
                visit edit_artwork_path(artwork)
                click_button 'Finish'

                artwork.tags.should == artwork.reload.tags
                artwork.medium.should == artwork.reload.medium
            end

            it "rollsback on error" #do
            #    visit edit_artwork_path(artwork)

            #    fill_in 'artwork_description', :with => 'abcd'
            #    fill_in 'original_price', :with => '0'

            #    click_button 'Finish'
            #    
            #    artwork.reload.description.should_not == 'abcd'
            #end
            
            it "persists valid changes" do
                new_title = 'new title'
                new_description = 'new description'

                visit edit_artwork_path(artwork)

                fill_in 'artwork_title', :with => new_title
                fill_in 'artwork_description', :with => new_description

                click_button 'Finish'
                artwork.reload

                artwork.title.should == new_title
                artwork.description.should == new_description
            end
        end
    end
end
