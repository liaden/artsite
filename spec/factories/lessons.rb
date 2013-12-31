require 'factory_girl'

FactoryGirl.define do
    factory :lesson do
       name { Faker::Lorem.words }
       date { 7.days.from_now }
       free_spots { rand(10) + 1 }
       description { Faker::Lorem.sentences } 
    end

    factory :old_lesson, :parent => :lesson do
        date { 7.days.ago }
    end

    factory :full_lesson, :parent => :lesson do
        free_spots 0
    end
end
