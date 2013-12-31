
require 'spec_helper'

describe Print do

    before(:each) { mock_paperclip_post_process } 

    it 'fails without artwork' do
        FactoryGirl.build(:print, :artwork => nil).should_not be_valid
    end

    it 'fails without dimensions' do
        FactoryGirl.build(:print, :dimensions => nil).should_not be_valid
    end

    it "picks 5x7" do
        Print.ratio_to_small(5.0/7.0).should == "5x7"
    end

    it "picks 4x6" do
        Print.ratio_to_small(4.0/6.0).should == "4x6"
    end

    it "picks 8x10" do
        Print.ratio_to_medium(8.0/10.0).should == "8x10"
    end

    it "picks 8x12" do
        Print.ratio_to_medium(8.0/12.0).should == "8x12"
    end

    it "picks 11x14" do
        Print.ratio_to_large(11.0/14.0).should == "11x14"
    end

    it "picks 12x18" do
        Print.ratio_to_large(12.0/18.0).should == "12x18"
    end

    it "picks 16x20" do
        Print.ratio_to_xlarge(16.0/20.0).should == "16x20"
    end

    it "picks 20x30" do
        Print.ratio_to_xlarge(20.0/30.0).should == "20x30"
    end


    context "when its original" do
        before(:each) do
            @print = FactoryGirl.create(:print, :material => 'original')
        end

        it "can create" do
            @print.should be_valid
        end

        it "is not an original" do
            @print.original?.should be_true
        end
    end

    context "when it's canvas" do
        before(:each) do
            @print = FactoryGirl.create(:print, :material => 'canvas')
        end

        it "can create" do
            @print.should be_valid
        end

        it "is not an original" do
            @print.original?.should be_false
        end

    end

    context "when it is photopaper" do
        before(:each) do
            @print = FactoryGirl.create(:print, :material => 'photopaper')
        end

        it "can create" do
            @print.should be_valid
        end

        it "is not an original" do
            @print.original?.should be_false
        end
    end

    it "has named sizes" do
        Print.sizes.should_not be_empty
    end

    it "has materials" do
        Print.materials.should_not be_empty
    end

    it "has sizes other than original" do
        Print.sizes_sans_original.should_not be_empty
    end

    it "has materials other than original" do
        Print.materials_sans_original.should_not be_empty
    end

    
end

