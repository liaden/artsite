require 'faker'

FactoryGirl.define do
    factory :address do |f|
        f.recipient { Faker::Name::name }
        f.line1 { Faker::Address::street_address }
        f.line2 { "" }
        f.city { Faker::Address::city }
        f.state { Faker::Address::state_abbr }
        f.zipcode { Faker::Address::zip_code }
    end

    factory :alabama_address, :parent => :address do |f|
        f.state "AL"
    end
end
