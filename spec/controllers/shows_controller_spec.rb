
require 'spec_helper'

describe ShowsController do
  let(:show) { FactoryGirl.create(:show) }

  context "as admin" do
    before(:each) { login :admin }

    context "GET #new" do
      it "assigns @show" do
        get :new
        assigns(:art_show).should be_an_instance_of(Show)
      end
    end

    context "GET #show" do
      it "assigns @show" do
        get :show, :id => show.id
        assigns(:art_show).should be_an_instance_of(Show)
      end
    end

    context "POST #create" do
      it "creates a new show" do
        expect { post :create, :show => FactoryGirl.attributes_for(:show) }.to change{Show.count}.by(1)
      end

      it "redirects back to #new" do
        post :create, FactoryGirl.attributes_for(:show)
        response.should redirect_to(new_show_path)
      end
    end

    context "GET #edit" do
      it "assigns @show" do
        get :edit, :id => show.id
        assigns(:art_show).should be_an_instance_of(Show)
      end
    end

    context "POST #update" do
      it "updates the name" do
        post :update, :id => show.id, :show => {:name => "herp derp"}
        show.reload.name.should == "herp derp"
      end

      it "shows the updated show" do
        post :update, :id => show.id, :show => FactoryGirl.attributes_for(:show)

        response.should render_template('show')
      end
    end
  end

  context "as guest" do
    let(:item) { show }
    let(:redirect_url) { schedule_path }
    let(:attrs) { FactoryGirl.attributes_for(:show) }
    let(:table) { Show }

    it_behaves_like 'unauthorized GET new'
    it_behaves_like 'unauthorized POST create'
    it_behaves_like 'unauthorized GET edit'
    it_behaves_like 'unauthorized PUT update'
    it_behaves_like 'unauthorized DELETE destroy'
  end
end
