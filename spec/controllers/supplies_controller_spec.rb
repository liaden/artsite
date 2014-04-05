require 'spec_helper'

describe SuppliesController do
  let(:supply) { FactoryGirl.create(:supply) }

  describe 'as admin' do
    before(:each) { login :admin }
    render_views 

    describe 'create' do
      it 'adds item to database' do
        expect {
          post :create, :supply => FactoryGirl.attributes_for(:supply)
        }.to change{Supply.count}.by(1)
      end

      it 'redirects to show page on success' do
        post :create, :supply => FactoryGirl.attributes_for(:supply)
        response.should redirect_to(supply_path(Supply.first))
      end
    end

    describe 'edit' do
      it 'renders the page' do
        get :edit, :id => supply.id
      end
    end

    describe 'update' do
      it 'redirects to show page on success' do
        post :update, :id => supply.id, :supply => { :name => 'DIFFERENT' }
        response.should redirect_to(supply_path(supply))
      end

      it 'persists changes' do
        post :update, :id => supply.id, :supply => { :name => 'DIFFERENT' }
        supply.name.should_not == supply.reload.name
      end
    end

    describe 'destroy' do
      it 'removes item from database' do
        supply
        expect { post :destroy, :id => supply.id }.to change{Supply.count}.by(-1)
      end

      it 'redirects to index page' do
        post :destroy, :id => supply.id
        response.should redirect_to(supplies_path)
      end
    end
  end

  describe 'as guest' do
    describe 'renders views for' do
      render_views 

      it 'showing the supply' do
        get :show, :id => supply.id
      end

      it 'listing all supplies' do
        supply
        get :index
      end
    end

    let(:item) { supply }
    let(:redirect_url) { supplies_path }
    let(:attrs) { FactoryGirl.attributes_for(:supply) }
    let(:table) { Supply }

    it_behaves_like 'unauthorized GET new'
    it_behaves_like 'unauthorized POST create'
    it_behaves_like 'unauthorized GET edit'
    it_behaves_like 'unauthorized PUT update'
    it_behaves_like 'unauthorized DELETE destroy'
  end
end
