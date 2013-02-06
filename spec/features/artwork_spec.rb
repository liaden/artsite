require 'spec_helper'

describe "artworks" do
    before(:each) do
        @artwork = FactoryGirl.create(:tagged_artwork_in_medium)
        FactoryGirl.create(:print, :artwork => @artwork)
        FactoryGirl.create(:original, :artwork => @artwork)
        FactoryGirl.create(:canvas, :artwork => @artwork)
    end

    describe "create" do
        it "makes a new artwork" do
        end
        it "does not create duplicate tags or mediums"
    end
    
    describe "index" do
        it "has the navbar/footer" do
            visit artworks_path
            check_footer_header page
        end
        
        it "shows the tags and mediums" do
            visit artworks_path
            within("#mediums") do
                @artwork.medium.each { |medium| page.should have_content(medium.name) }
            end

            within("#tags") do
                @artwork.tags.each { |tag| page.should have_content(tag.name) }
            end
        end
    end

    describe "edit" do
        before(:each) do
            @user = FactoryGirl.create(:admin, :username => 'holly')

            visit login_path
            fill_in 'user_session_username', :with => @user.username
            fill_in 'user_session_password', :with => 'abcd'

            click_button('Login')
        end

        it "does not create duplicate tags or mediums" do
            visit edit_artwork_path(@artwork)
            click_button 'Finish'

            @artwork.tags.should == @artwork.reload.tags
            @artwork.medium.should == @artwork.reload.medium
        end

        it "rollsback on error" #do
        #    visit edit_artwork_path(@artwork)

        #    fill_in 'artwork_description', :with => 'abcd'
        #    fill_in 'original_price', :with => '0'

        #    click_button 'Finish'
        #    
        #    @artwork.reload.description.should_not == 'abcd'
        #end

        it "persists valid changes" do
            new_title = 'new title'
            new_description = 'new description'
            new_price = '1000.01'

            visit edit_artwork_path(@artwork)

            fill_in 'artwork_title', :with => new_title
            fill_in 'artwork_description', :with => new_description
            fill_in 'original_price', :with => new_price

            click_button 'Finish'
            @artwork.reload

            @artwork.title.should == new_title
            @artwork.description.should == new_description
            @artwork.original.price.to_s.should == new_price
        end
    end

    describe "show" do
        it "has open graph tags" do
            visit artwork_path(@artwork)
            page.should have_facebook_metatags
        end
       
       it "has the navbar/footer" do
            visit artworks_path
            check_footer_header page
        end

        it "has fullsized artwork" do
            visit artwork_path(@artwork)
            find('#artwork_image')[:src].should == @artwork.image.url
        end

        it "has only these tags and mediums" do
            @new_artwork = FactoryGirl.create(:tagged_artwork_in_medium)

            visit artwork_path(@artwork)
            within('#tags') do
                @new_artwork.tags.each { |tag| page.should_not have_content(tag.name) }
            end

            within('#mediums') do
                @new_artwork.medium.each { |medium| page.should_not have_content(medium.name) }
            end
        end
            

        it "has all sizes listed for purchase"
        it "shows soldout for the original" do
            @artwork.original.update_attributes :is_sold_out => true

            visit artwork_path(@artwork)
            within('#original') do
                page.should have_content("Sold")
                page.should_not have_selector("input[type='submit']")
            end
        end
        it "has all the framing options"
        it "computes the total"
    end
end
