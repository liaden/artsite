require 'spec_helper'

describe 'Manage Art Supplies' do
  let(:supply) { FactoryGirl.create(:supply) }
  context 'as admin' do
    before(:each) do
      FactoryGirl.create(:show)
      FactoryGirl.create(:artwork)
    end

    before(:each) { login_step :admin }

    describe 'active admin index page' do
      it 'shows all supplies' do
        FactoryGirl.create(:supply)
        FactoryGirl.create(:supply)

        visit admin_supplies_path

        Supply.pluck(:name).each do |supply_name|
          page.should have_content(supply_name)
        end
      end
    end

    describe 'creating new supply' do
      it 'shows confirmation' do
        visit new_supply_path

        fill_in_supply_form
        submit_supply_form

        within('#flash-notice') { page.should have_content('Successfully created') }
      end

      it 'shows errors given bad data' do
        visit new_supply_path

        supply.name = ''
        fill_in_supply_form(supply)
        submit_supply_form

        within('#form-error') { page.should have_content('Name') }
      end

      it 'previews markdown', :js => true do
        visit new_supply_path

        fill_in_supply_form(supply)

        fill_in :supply_description, :with => '# The header\n\n*item*'
        
        click_link('preview')

        within('#description_preview') do
          page.should have_content("The header")
          all('h1').should have(1).item
        end
      end
    end

    describe 'editing supply' do
      it 'shows confirmation' do
        visit edit_supply_path(supply)

        fill_in :supply_name, :with => 'DIFFERENT'
        click_button('Create')

        within('#flash-notice') { page.should have_content('Successfully updated') }
      end

      it 'previews the markdown', :js => true do
        visit edit_supply_path(supply)

        fill_in :supply_description, :with => '# The header\n\n*item*'
        
        click_link('preview')

        within('#description_preview') do
          page.should have_content("The header")
          all('h1').should have(1).item
        end
      end

      it 'shows errors given bad data' do
        visit edit_supply_path(supply)

        fill_in :supply_name, :with => ''
        click_button('Create')

        within('#form-error') { page.should have_content('Name') }
      end

      it 'show page links to edit page' do
        visit supply_path(supply)
        click_link('edit')
        click_button('Create')
      end
    end

    describe 'removing supply' do
      it 'shows confirmation' do
        supply
        visit supplies_path

        click_link('delete')
        page.should have_content('successfully destroyed')
      end
    end
  end

  context 'as guest' do
    describe 'viewing all supplies' do
      before(:each) { supply }

      it 'has category links' do
        visit supplies_path
        click_link('Brushes')
        click_link('Paper')
        click_link('Media')
      end

      it 'truncates description of supplies' do
        visit supplies_path

        page.should have_content(supply.short_description)
        page.should_not have_content(supply.description)
      end

      it 'has a more info link' do
        visit supplies_path
        click_link('more info')
        page.should have_content(supply.name)
      end

      it 'links to dickblick' do
        visit supplies_path
        find_link(supply.name)[:href].should match(/dickblick.com/)
      end
    end

    describe 'viewing a supply' do
      it 'links to dickblick' do
        visit supply_path(supply)
        find_link('dickblick')[:href].should match(/dickblick.com/)
      end

      it 'renders markdown' do
        supply.update_attributes :description => "# Blah \n\n* item 1 \n* item 2"

        visit supply_path(supply)
        within('#supply-description') do
          page.should have_css("h1")
          page.should have_css("li")
        end
      end

      it 'has a list of artworks that were created with it' 
    end
  end
end
