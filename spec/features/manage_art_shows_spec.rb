require 'spec_helper'

describe "manage art shows" do
  context 'as admin' do
    before(:each) { FactoryGirl.create(:artwork) }
    before(:each) { login_step :admin }

    let(:show) { FactoryGirl.create(:show) }

    describe 'active admin index page' do
      it 'lists all shows' do
        FactoryGirl.create(:show)
        FactoryGirl.create(:show)

        visit admin_shows_path

        Show.pluck(:name).each do |show_name|
          page.should have_content(show_name)
        end
      end
    end

    describe 'editing' do
      it 'shows validation errors' do
        visit edit_show_path(show)
         
        fill_in_form(FactoryGirl.build(:show, :name => ''))
        submit_art_show_form

        within('div#form-error') do
          page.should have_content('Name') 
        end
      end

      it 'has the date formated as mm/dd/yyyy' do
        visit edit_show_path(show)

        find_field('show_date').value.should == I18n.l(show.date)
      end

      it 'shows confirmation on success' do
        visit edit_show_path(show)
        
        fill_in_form(FactoryGirl.build(:show, :name => 'Different'))
        submit_art_show_form

        within('#flash-notice') { page.should have_content('successfully updated') }
      end

      it 'shows edited show on success' do
        visit edit_show_path(show)
        
        fill_in_form(FactoryGirl.build(:show, :name => 'Different'))
        submit_art_show_form

        page.should have_content('Different')
      end
    end

    describe 'creation' do
      before(:each) { visit new_show_path }

      it 'shows validation errors' do
        fill_in_form FactoryGirl.build(:show, :description => nil)
        submit_art_show_form

        within('#form-error') { page.should have_content('Description') }
      end

      it 'shows confirmation on success' do
        fill_in_form
        submit_art_show_form
        
        within('#flash-notice') { page.should have_content('Successfully') }
      end
    end

    describe 'show page' do
      before(:each) { visit show_path(show) }

      it 'shows edit button' do
        page.should have_css('#edit-address')
      end

      describe 'with best in place functionality' do
        #it 'can edit show date', :js => true do
        #  id = "best_in_place_show_#{show.id}_date"

        #  page.execute_script <<-JS
        #    $("##{id}").click()
        #    $(".ui-state-default").click()
        #  JS

        #  show.date.should_not == show.reload.date
        #end

        it 'address links to google maps'
        it 'start editing address with edit link' 
      end
    end
  end

  context 'as guest' do
    describe 'show page' do
      it 'does not show edit link' do
        page.should_not have_css('#edit-address')
      end

      it 'does not enable best in place editing' do
        page.should_not have_css('.best_in_place')
      end

      it 'the address links to google maps'
    end
  end
  
  describe 'schedule of upcoming events' do
    before(:each) do
      FactoryGirl.create(:show)
      FactoryGirl.create(:show)
      FactoryGirl.create(:show)
    end

    it 'lists next three events' do
      visit schedule_path
      all('.upcoming-event').should have(3).items
    end

    it 'has a table with all events' do
      FactoryGirl.create(:show, :date => 14.days.from_now)
      visit schedule_path

      within('#all-events') do
        all('tbody tr').should have(4).items
      end
    end

    it 'does not list old events in table' do
      FactoryGirl.create(:show, :date => 7.days.ago)
      visit schedule_path

      within('#all-events') do
        all('tbody tr').should have(3).items
      end
    end
  end
end
