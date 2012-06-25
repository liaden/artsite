require 'factory_girl'

FactoryGirl.define do
    factory :user do |user|

    end

    factory :artwork do|artwork|

    end

    factory :print do |print|

    end

    factory :tag do |tag|
    end

    factory :medium do |medium|
    end

    factory :artwork_with_extras, :parent => :artwork do |artwork|
        after(:build) do |built_art| 
            built_art.tags << Factory(:tag, :name => "BDSM")
            built_art.tags << Factory(:tag, :name => "BallJointDolls")
            built_art.medium << Factory(:medium, :name => "WaterColor")
            built_art.medium << Factory(:medium, :name => "Ink")
            # JOEL TODO: add prints in  here
        end
    end
end
