require 'faker'

FactoryGirl.define do
    factory :order do |f|
        f.state "open"
        f.guest_email nil
    end
    
    factory :order_with_email, :parent => :order do |f|
        f.guest_email { Faker::Internet::email }
    end

    factory :addressed_order do |f|
        f.after(:create) { |o| FactoryGirl.create(:address, :order => o) }
    end

    factory :closed_order, :parent => :order do |f|
        f.state "closed"
    end

    factory :user_order, :parent => :order do |f|
        f.after(:create) { |o| FactoryGirl.create(:user, :orders => [o]) }
    end
end


