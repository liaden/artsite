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
  end

  context 'as admin' do
    before(:each) { login :admin }
    let(:page) { FactoryGirl.create(:page) }

    it 'updates content' do
      put :update, :id => page.id, :page=> { :content => 'abcd' }
      page.reload.content.should == 'abcd'
    end
  end
end
