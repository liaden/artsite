require 'spec_helper'

describe Lesson do
    let(:lesson) { FactoryGirl.create(:lesson) }
    
    it 'creates' do
        lesson.should be_an_instance_of(Lesson)
    end

    it 'requires a name' do
        FactoryGirl.build(:lesson, :name => nil).should_not be_valid
    end

    it 'requires a description' do
        FactoryGirl.build(:lesson, :description => nil).should_not be_valid
    end

    it 'filters upcoming lessons' do
        FactoryGirl.create :lesson
        FactoryGirl.create :old_lesson

        Lesson.upcoming.should have(1).item
    end

end
