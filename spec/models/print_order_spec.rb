require 'spec_helper'

describe PrintOrder do
    context "has a price" do
        it "is 5x7 with no frame" do
            print_order = FactoryGirl.create :print_order, :print => FactoryGirl.create(:print, :dimensions => "5x7")
            print_order.price.should == 5.0
        end

        it "is 5x7 with a frame" do
            print_order = FactoryGirl.create :framed_print_order, :print => FactoryGirl.create(:print, :dimensions => "5x7")
            print_order.price.should == 15.0
       end 

       it "is 5x7 with frame_size set to nil" do
            print_order = FactoryGirl.create :print_order, :print => FactoryGirl.create(:print, :dimensions => "5x7"), :frame_size => nil
            print_order.price.should == 5.0
       end

       it "does not add any framing cost for an original" do
            print_order = FactoryGirl.create :print_order, :print => FactoryGirl.create(:original, :dimensions => "5x7", :price => 5.00), :frame_size => "2.00"
            print_order.price.should == 5.0
       end 
    end

    context "on the class" do
        context "has a frame price" do
            it "is 5x7 with no frame" do
                PrintOrder.frame_price("5x7", "no_frame").should == 0.0
            end

            it "is 5x7 with 2.00\" frame" do
                PrintOrder.frame_price("5x7", "2.00").should == 10.0
            end
        end
    end
end
