require 'spec_helper'

describe ArticlesController do
  context 'as guest' do
    let(:attrs) { Hash.new(:article => FactoryGirl.attributes_for(:article, :content => 'abcd')) }
    let(:redirect_url) { home_path }
    let(:item) { FactoryGirl.create(:article) }
    let(:table) { Article }

    it_behaves_like 'unauthorized GET edit'
    it_behaves_like 'unauthorized PUT update'
  end

  context 'as admin' do
    before(:each) { login :admin }
    let(:article) { FactoryGirl.create(:article) }
    it 'updates content' do
      put :update, :id => article.id, :article => { :content => 'abcd' }
      article.reload.content.should == 'abcd'
    end
  end
end
