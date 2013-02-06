require 'faker'

FactoryGirl.define do
    factory :artwork_medium do |f|
        f.artwork { Factory.create(:artwork) }
        f.medium { Factory.create(:medium) }
    end
end

