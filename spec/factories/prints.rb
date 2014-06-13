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

def mass_make_prints factory, artwork
    puts "Don't be stupid. This isn't for originals." if factory == :original
    [ FactoryGirl.create(factory, :artwork => artwork, :size_name => "medium", :dimensions => "8x10"),
      FactoryGirl.create(factory, :artwork => artwork, :size_name => "large", :dimensions => "11x14"),
      FactoryGirl.create(factory, :artwork => artwork, :size_name => "extra_large", :dimensions => "16x20") ]
end
