require 'spec_helper'

describe 'Manage pages' do
  let(:custom_page) { FactoryGirl.create(:page, :name => 'page 1') }

  context 'as admin' do
    before(:each) do
      visit pages_path 
      navbar_login_step :admin
    end

    describe 'index of pages' do
      before(:each) { custom_page }

      it 'shows all pages' do
        FactoryGirl.create(:video, :name => 'page 2')

        visit pages_path
        page.should have_content('page 1')
        page.should have_content('page 2')
      end

      it 'shows name' do
        visit pages_path
        page.should have_content(custom_page.name)
      end

      it 'shows creation date' do
        visit pages_path

        page.should have_content(Time.now.year.to_s)
        page.should have_content(Time.now.month.to_s)
        page.should have_content(Time.now.day.to_s)
      end
    end

    describe 'active admin index' do
     before(:each) { custom_page }

     it 'shows all pages' do
       FactoryGirl.create(:page, :name => 'page 2') 
       visit admin_pages_path

       Page.pluck(:name).each do |page_name|
         page.should have_content(page_name)
       end
     end

     it 'has edit page link' do
       visit admin_pages_path
       click_link 'edit'

       page.should have_css('#page_name')
     end
    end

    describe 'editing page' do
      it 'previews the final page'
      it 'publishes the page'
      it 'shows confirmation on success'
      it 'shows errors on failure'
    end

    describe 'creating new page' do
      it 'previews the final page'
      it 'publishes the page'
      it 'shows confirmation on success'
      it 'shows errors on failure'
    end

    describe 'deleting old page' do
      it 'can delete from index page'
      it 'can delete from show page'
    end

    describe 'viewing page' do
      describe 'best in place functionality' do
        it 'edits name'
        it 'edits content'
        it 'edits page type'
      end
    end
  end

  context 'as guest' do
    describe 'viewing page' do
      it 'renders the markdown' do
        custom_page.update_attributes :content => "# title \n\n* item 1\n* item 2"
        visit page_path(custom_page)

        within('#page-content') do
          page.should have_css('h1')
          page.should have_css('li')
        end
      end

      it 'does not have an edit button' do
        visit page_path(custom_page)
        page.should_not have_content('Edit')
      end

      it 'does not support best in place' do
        visit page_path(custom_page)
        page.should_not have_css('.best_in_place')
      end
    end
  end
end
