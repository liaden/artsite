require 'spec_helper'

describe LessonsController do
    let(:table) { Lesson }
    let(:redirect_url) { lessons_path }
    let(:attrs) { FactoryGirl.attributes_for :lesson }
    let(:lesson) { FactoryGirl.create :lesson }
    let(:item) { lesson } 

    context 'as guest' do
        describe 'GET index' do
            before(:each) { lesson }

            it 'assigns lessons' do
                get :index
                assigns[:lessons].should have(1).item
            end

            it 'does not show old lessons' do
                FactoryGirl.create :old_lesson
                get :index
                assigns[:lessons].should have(1).item
            end
        end

        describe 'GET show' do
            it 'assigns the lesson' do
                get :show, :id => lesson.id
                assigns[:lesson].should == lesson
            end
        end

        it_behaves_like 'unauthorized POST create'
        it_behaves_like 'unauthorized GET new'
        it_behaves_like 'unauthorized PUT update' 
        it_behaves_like 'unauthorized GET edit'
        it_behaves_like 'unauthorized DELETE destroy'
    end

    context 'as admin' do
        before(:each) { login :admin }

        describe 'GET new' do
            it 'assigns instance' do
                get :new
                assigns[:lesson].should be_an_instance_of(Lesson)
            end
        end

        describe 'POST create' do
            it 'creates lesson' do
                expect { post :create, :lesson => FactoryGirl.attributes_for(:lesson) }.to change { Lesson.count }.by(1)
            end

        end

        describe 'GET edit' do
            it 'assigns lesson' do
                get :edit, :id => lesson.id
                assigns[:lesson].should == lesson
            end
        end

        describe 'PUT update' do
            it 'updates the lesson' do
                put :update, :id => lesson.id, :lesson => { :name => "new name" } 
                lesson.reload.name.should == "new name"
            end
        end

        describe 'DELETE destroy' do
            it 'removes the lesson' do
                lesson
                expect { delete :destroy, :id => lesson.id }.to change { Lesson.count }.by(-1)
            end
        end
    end
end

