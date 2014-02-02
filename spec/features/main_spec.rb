require 'spec_helper'

describe "Homepage" do
    before(:each) { mock_paperclip_post_process }
    before(:each) { FactoryGirl.create(:artwork) }

    it "has a carousel" do
        visit home_path

        page.should have_selector('#banner-image')
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
        page.should have_selector('footer')
        page.should have_selector('nav')
    end

    it "has a 404 for unknown resources"

    it "has commission information"
    it "has latest tutorial"
    it "has latest artwork"
    it "has next upcoming convention"

    context 'as admin' do
      before(:each) { login_step :admin }

      it 'shows admin navbar', :js => true do
        visit home_path
        page.should have_css('nav#admin-navbar')
      end
    end
end

