require 'faker'

FactoryGirl.define do
    factory :medium do |f|
        f.name { Faker::Lorem::words * " "}
    end
end

