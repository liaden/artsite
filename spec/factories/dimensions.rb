require 'faker'

FactoryGirl.define do
    factory :dimension do
        height { Integer( Random.rand() * 20 + 1 ) }
        width { Integer ( Random.rand() * 20 + 1 ) }
    end
end
