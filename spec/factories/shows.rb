require 'faker'

FactoryGirl.define do
    factory :show do |f|
        f.name { Faker::Lorem::words * " " }
        f.date { 7.days.from_now }
        f.building { Faker::Lorem::words * " " }
        f.address { Faker::Address::street_address }
        f.show_type { "Gallery" }
    end
end
