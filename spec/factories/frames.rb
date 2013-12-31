require "faker"

FactoryGirl.define do
  factory :frame do |f|
    f.thickness 2.0
    f.depth 1.0
    f.price_per_inch 0.2
    f.linear_inches 100
  end

  factory :no_frame, :parent => :frame do |f|
    f.thickness 0.0
    f.depth 0.0
    f.price_per_inch 0.0
    f.linear_inches 0
  end
end
