require 'spec_helper'

describe PagesController do
  context 'as guest' do
    let(:attrs) { Hash.new(:page => FactoryGirl.attributes_for(:page, :content => 'abcd')) }
    let(:redirect_url) { home_path }
    let(:item) { FactoryGirl.create(:page) }
    let(:table) { Page }

    it_behaves_like 'unauthorized GET new'
    it_behaves_like 'unauthorized POST create'
    it_behaves_like 'unauthorized GET edit'
    it_behaves_like 'unauthorized PUT update'
    it_behaves_like 'unauthorized DELETE destroy'

    context 'renders views for' do
      let(:test_page) { FactoryGirl.create(:page) }

      render_views

      it 'show page' do
        get :show, :id => test_page.id
      end
    end
  end

  context 'as admin' do
    before(:each) { login :admin }
    let(:test_page) { FactoryGirl.create(:page) }

    describe 'update' do
      describe 'valid data' do
        before(:each) do
          put :update, :id => test_page.id, :page => { :content => 'abcd' }
        end

        it 'persists changes' do
          test_page.reload.content.should == 'abcd'
        end

        it 'redirects to show page' do
          response.should redirect_to(page_path(test_page))
        end
      end

      describe 'invalid data' do
        before(:each) do
          put :update, :id => test_page.id, :page => { :name => nil }
        end

        it 'does not persist invalid data' do
          test_page.name.should == test_page.reload.name
        end

        it 'renders edit page' do
          response.should render_template(:edit)
        end
      end
    end

    describe 'create' do
      describe 'valid data' do
        it 'saves new page to database' do
          expect {
            post :create, :page => FactoryGirl.attributes_for(:page)
          }.to change{Page.count}.by(1)
        end

        it 'redirects to index page' do
          post :create, :page => FactoryGirl.attributes_for(:page)
          response.should redirect_to(page_path(Page.first))
        end
      end

      describe 'invalid data' do
        it 'does not save record' do
          expect {
            post :create, :page => FactoryGirl.attributes_for(:page, :page_type => 'abcd')
          }.to_not change{Page.count}
        end

        it 'renders new page' do
          post :create, :page => FactoryGirl.attributes_for(:page, :page_type => 'abcd')
          response.should render_template(:new)
        end
      end
    end

    describe 'destroy' do
      it 'redirects to index page' do
        post :destroy, :id => test_page.id
        response.should redirect_to(pages_path)
      end

      it 'deletes the page' do
        test_page

        expect {
          post :destroy, :id => test_page.id
        }.to change{Page.count}.by(-1)
      end
    end

    context 'renders views for' do
      render_views 

      it 'index page' do
        get :index
      end
      
      it 'new page' do
        get :new
      end

      it 'create page' do
        post :create, :page => FactoryGirl.attributes_for(:page)
      end

      it 'edit page' do
        get :edit, :id => test_page.id
      end

      it 'destroy page' do
        post :destroy, :id => test_page.id
      end
    end
  end
end
