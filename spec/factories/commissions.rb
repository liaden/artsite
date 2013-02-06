require 'faker'

FactoryGirl.define do
    factory :commission do |f|
        f.email { Faker::Internet::email }
        f.customer { Faker::Name::name }
        f.width { 11 }
        f.height { 14 }
        f.medium { "watercolor" }
        f.comments { Faker::Lorem::sentences }
    end
end

