require 'faker'

FactoryGirl.define do
    factory :print do |f|
        f.is_sold_out  false 
        f.is_on_show  false 
        f.size_name  "small" 
        f.material  "photopaper" 
        f.dimensions  "8x10" 
        f.price  5.00 
        f.sold_count  0 
        f.inventory_count  0 
        f.artwork { FactoryGirl.create(:artwork) }
    end

    factory :original, :parent => :print do |f|
        f.material "original"
        f.size_name "original"
    end

    factory :canvas, :parent => :print do |f|
        f.material "canvas"
    end
end

