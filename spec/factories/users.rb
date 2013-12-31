require 'faker'

FactoryGirl.define do
    factory :user do |f|
        f.username { Faker::Internet::user_name + '111' }
        f.email { Faker::Internet::email }
        f.password { "abcd" }
        f.password_confirmation { "abcd" }
        # stop authlogic auto login
        f.skip_session_maintenance true
    end
end

FactoryGirl.define do
    factory :admin, :parent => :user do |f|
        f.privilege 1
    end
end


