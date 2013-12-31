require "faker"

FactoryGirl.define do
  factory :matte_color do |f|
    f.color "red"
    f.image { File.new("./spec/images/watercolor.png") }
    f.price_per_square_inch 0.006
    f.inventory_count 1
  end

  factory :sold_out_matte, :parent => :matte do |f|
    f.inventory_count 0
  end
end

