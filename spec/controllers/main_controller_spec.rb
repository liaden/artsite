require 'spec_helper'

describe MainController do
  before(:each) { mock_paperclip_post_process }
  before(:each) { FactoryGirl.create(:artwork) }

  describe "GET index" do
    it "should assign @artwork" do
      FactoryGirl.create(:artwork)

      get :index
      assigns(:artwork).should be_an_instance_of(Artwork)
    end

    it "should assign the next show" do
      FactoryGirl.create(:show, :date => 7.days.from_now)

      get :index
      assigns(:next_show).should be_an_instance_of(Show)
    end

    context 'when it renders view' do
      render_views

      it 'no upcoming shows does not raise an error' do
        expect { get :index }.to_not raise_error
      end
    end
  end

  describe 'subnavbar' do
    render_views

    context 'as a guest' do
      it 'returns nothing' do
        get :subnavbar
        response.body.should be_empty
      end
    end

    context 'as a user' do
      it 'returns nothing' do
        login :user

        get :subnavbar
        response.body.should be_empty
      end
    end

    context 'as admin' do
      it 'returns the subnav' do
        login :admin

        get :subnavbar
        response.should render_template('admin_sub_navbar')
      end
    end
  end
end

