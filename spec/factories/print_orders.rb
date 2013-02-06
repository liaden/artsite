require 'faker'

FactoryGirl.define do
    factory :print_order do |f|
        f.print { FactoryGirl.create :print }
        f.order { FactoryGirl.create :order }
        f.frame_size "no_frame"
    end

    factory :framed_print_order, :parent => :print_order do |f|
       f.frame_size "2.00"
   end
end


