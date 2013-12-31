require 'faker'

FactoryGirl.define do
    factory :recommended_matte_color do |f|
        f.artwork { FactoryGirl.create :artwork }
        f.matte_color { FactoryGirl.create :matte_color }
    end
end


