require 'faker'

FactoryGirl.define do
  factory :print_order do |f|
    f.print { FactoryGirl.create(:print) }
    f.order { FactoryGirl.create(:order) }
  end
end
