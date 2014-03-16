require 'spec_helper'

describe PrintsController do
    let(:print) { FactoryGirl.create(:print) }
    let(:artwork_without_prints) { FactoryGirl.create(:artwork) }

    context 'as admin' do
        before(:each) { login(:admin) }
        
        context '/index' do
            before(:each) { get :index, :artwork_id => print.id }

            it 'assigns @artwork' do
                assigns(:artwork).should_not be_nil
            end

            it 'assigns @prints' do
                assigns(:prints).should_not be_empty
            end
        end

        context 'canvas' do 
            it 'on new, sets a canvas print' do
                  get :canvas, :artwork_id => print.artwork_id
                assigns(:print).should be_canvas
            end

            it 'creates a canvas print' do
                post :create, :print => FactoryGirl.attributes_for(:canvas), :artwork_id => artwork_without_prints.id, :canvas => 1
                Print.first.should be_canvas
            end
        end

        context 'photopaper' do
            it 'on new, sets a regular print' do
                get :photopaper, :artwork_id => print.artwork_id
                assigns(:print).should be_photopaper
            end

            it 'creates regular print' do
                post :create, :print => FactoryGirl.attributes_for(:print), :artwork_id => artwork_without_prints.id, :photopaper => 1
                Print.first.should be_photopaper 
            end
        end

        context 'original' do
            it 'on new, sets a regular print' do
                get :original, :artwork_id => print.artwork_id
                assigns(:print).should be_original
            end

            it 'creates an original print'  do
                post :create, :print => FactoryGirl.attributes_for(:original), :artwork_id => artwork_without_prints.id, :original => 1
                Print.first.should be_original
            end
        end

        context '/edit' do
            it 'assigns the print' do
                get :edit, :artwork_id => print.artwork_id, :id => print.id
                assigns(:print).should == print
            end
        end

        context '/update' do
            it 'updates the price' do
                put :update, :artwork_id => print.artwork_id, :id => print.id, :print => { :price => 0.01 }
                print.reload.price.should == 0.01
            end
        end

        context '/destroy' do
            it 'removes the print' do
                @print = print

                expect {
                    post :destroy, :artwork_id => print.artwork_id, :id => print.id
                }.to change{Print.all.size}.by(-1)
            end
        end
    end

    context 'as guest' do
        context 'redirects for' do
            after(:each) { response.should redirect_to('/') }
               
            it '/edit' do
                get :edit, :id => print.id, :artwork_id => print.artwork.id
            end

            it '/create' do
                post :create, FactoryGirl.attributes_for(:print).merge(:artwork_id => print.artwork.id)
            end

            it '/update' do
                post :update, FactoryGirl.attributes_for(:print).merge(:artwork_id => print.artwork.id, :id => print.id)
            end

            it '/destroy' do
                post :destroy, :artwork_id => print.artwork.id, :id => print.id 
            end
        end
    end
end
