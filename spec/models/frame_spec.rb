require 'spec_helper'

describe Frame do
    before(:each) { mock_paperclip_post_process }

    it "requires a price" do
        FactoryGirl.build(:frame, :price_per_inch => nil).should_not be_valid
    end

    it "requires a thickness" do
        FactoryGirl.build(:frame, :thickness => nil).should_not be_valid
    end

    it "requires a depth" do
        FactoryGirl.build(:frame, :depth => nil).should_not be_valid
    end

    it "can be unframed" do
        FactoryGirl.create(:no_frame)
        Frame.no_frame.should be_an_instance_of(Frame)
    end

    context "with a 2.00\" thick frame" do
        let(:frame) { FactoryGirl.create(:frame, :thickness => 2.00) }

        it "computes the perimeter" do
            frame.perimeter(:height => 20.0, :width => 16.0).should == 88.0
        end

        it "generates the framed with and height" do
            d = frame.height_width :height => 20.0, :width => 16.0
            d[:height].should == 24
            d[:width].should == 20
        end

        it "computes a logical price" do
            bigger_print = FactoryGirl.build(:print, :dimensions => "16x20")
            smaller_print = FactoryGirl.build(:print, :dimensions => "12x18")
            frame.price(bigger_print).should > frame.price(smaller_print)
        end

        it "has no cost for originals" do
            frame.price(FactoryGirl.build(:original)).to_i.should == 0
        end

    end

end
