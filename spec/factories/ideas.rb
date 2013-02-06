require 'faker'

FactoryGirl.define do
    factory :idea do |f|
        f.description { Faker::Lorem::paragraphs }
        f.by { Faker::Name::name }
        f.reference { "abCx14.jpg" }
    end
end


