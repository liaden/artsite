require 'spec_helper'

describe Matte do
    before(:each) { mock_paperclip_post_process }

    it "can be built" do
        FactoryGirl.create(:matte).should be_an_instance_of(Matte)
    end
    
    it "is it matted?" do
        FactoryGirl.create(:matte).matted?.should be_true
        FactoryGirl.create(:matte, :matte_color => nil).matted?.should be_false
    end

    context "if matted" do
        it "requires a size" do
            matte = FactoryGirl.build(:matte, :size => 0)
            matte.should_not be_valid 
        end

        it "computes the matted dimensions" do
            dimensions = FactoryGirl.create(:matte, :size => 2) .height_width :height => 1, :width => 1
            dimensions[:height].to_i.should == 5
            dimensions[:width].to_i.should == 5
        end

         it "has a logical price" do
            small = FactoryGirl.create(:matte, :size => 2)
            big = FactoryGirl.create(:matte, :size => 4)

            dimensions = { :width => 5, :height => 7 }

            big.price( dimensions ).should > small.price( dimensions )
         end

    end

    context "if not matted" do
    
        it "has the same size" do
            dimensions = { :height => 1, :width => 1 }
            FactoryGirl.create(:no_matte)
        end

        it "does not cost anything" do
            FactoryGirl.create(:no_matte).price(:height => 5, :width => 7).should == 0.0
        end

        it "can be unmatted" do
            Matte.unmatted.should be_an_instance_of(Matte)
            Matte.unmatted.matted?.should be_false
        end

    end
end

