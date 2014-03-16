require 'spec_helper'

describe UsersController do
  describe 'new' do
    it 'assigns user' do
      get :new
      assigns[:user].should be_an_instance_of(User)
    end
  end

  describe 'create' do
    it 'does not create an admin' do
      post :create, :user => FactoryGirl.attributes_for(:admin)
      User.first.should_not be_admin
    end

    it 'renders new if invalid user' do
      post :create, :user => FactoryGirl.attributes_for(:user, :username => nil)
      response.should render_template('new')
    end

    it 'redirects to home page if valid' do
      post :create, :user => FactoryGirl.attributes_for(:user)
      response.should redirect_to(home_path)
    end

    it 'creates a new user' do
      expect { 
        post :create, :user => FactoryGirl.attributes_for(:user) 
      }.to change{User.count}.by(1)
    end
  end
end
