require 'spec_helper'

describe "Homepage" do
    before(:each) { mock_paperclip_post_process }
    before(:each) { FactoryGirl.create(:artwork) }
    it "has a carousel" do
        visit home_path

        page.should have_selector("div.carousel")
        page.should have_selector("div.item")
        page.should have_selector("div.item img")
    end

    it "has artist's name" do
        visit home_path 
        page.should have_content("Holly Morningstar" )
    end
    it "has a like button" do
        visit home_path
        page.should have_selector("#facebook_like")
    end

    it "has open graph tags" do
        visit home_path 
        page.should have_facebook_metatags
    end

    it "has the navbar/footer" do
        visit home_path
        check_footer_header page
    end

    it "has a 404 for unknown resources"
end

