require "faker"

FactoryGirl.define do
  factory :matte do |f|
    f.size 1.0
    f.matte_color { FactoryGirl.create(:matte_color) }
  end

  factory :no_matte, :parent => :matte do |f|
    f.size 0.0
    f.matte_color nil
  end
end

