require 'spec_helper'

describe "Homepage" do
    context 'mock post process' do
      before(:each) { mock_paperclip_post_process }
      
      before(:each) do
        @artwork =  FactoryGirl.create(:artwork) 
        FactoryGirl.create(:show)
      end

      before(:each) { visit home_path }

      it "has artist's name" do
          page.should have_content("Holly Morningstar" )
      end

      it "has a like button" do
          page.should have_selector("#facebook_like")
      end

      it "has open graph tags" do
          page.should have_facebook_metatags
      end

      it "has a 404 for unknown resources"

      it "has commission information" do
        within('#commission-notification') do
          page.should have_content('Contact Me')
        end
      end

      it "has link to examples of commissions"

      it "has latest tutorial" do
        page.should have_css('#newest-tutorial')
      end

      it "has latest artwork" do
        page.should have_css('#newest-artwork')
      end

      it "has next upcoming convention" do
        page.should have_css('#next-convention')
      end

      describe 'footer' do
        it "has social media links in footer" do
          within('footer') do
            page.should have_css('#social-media-links')
          end
        end
          
        it "has artist's name" do
          within('footer') do
            page.should have_content('Holly Morningstar')
          end
        end

        it "has copyright date" do
          within('footer .copyright') do
            page.should have_content('All rights reserved')
            page.should have_content(DateTime.now.year.to_s)
          end
        end
      end
    end

    describe 'header' do
      before(:each) do 
        @artwork =  FactoryGirl.create(:artwork) 
        FactoryGirl.create(:show)
      end

      describe 'admin subnav' do
        it 'guest should not see admin navbar', :js => true do
          page.should_not have_css('nav#admin-navbar')
        end

        it 'admin sees admin navbar', :js => true do
          login_step :admin 
          visit home_path
          page.should have_css('nav#admin-navbar')
        end
      end
    end

end

