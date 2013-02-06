require 'faker'

FactoryGirl.define do
    factory :default_price do |f|
        f.price {  100.0 }
        f.material { DefaultPrice.valid_materials[1] }
        f.dimension { "#{15}x#{22}" }
    end

    factory :invalid_default_price, :parent => :default_price do |f|
        f.price nil 
    end

    factory :default_price_and_print, :parent => :default_price do |f|
        f.after(:create) do |default_price|
            FactoryGirl.create(:print, :dimensions => default_price.dimension, :material => default_price.material, :price => default_price.price)
        end
    end
end




