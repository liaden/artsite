require 'faker'

FactoryGirl.define do
    factory :print_order do |f|
        f.print { FactoryGirl.create(:print) }
        f.order { FactoryGirl.create(:order) }
        f.frame { FactoryGirl.create(:no_frame) }
        f.matte { FactoryGirl.create(:no_matte) }
    end

    factory :framed_print_order, :parent => :print_order do |f|
       f.frame { FactoryGirl.create(:frame) }
    end

    factory :matted_print_order, :parent => :print_order do |f|
        f.matte { FactoryGirl.create(:matte) }
    end

    factory :framed_matted_print_order, :parent => :matted_print_order do |f|
        f.frame { FactoryGirl.create(:frame) }
    end
end


