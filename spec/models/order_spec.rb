require 'spec_helper'

describe Order do
    it "fails on bad data" do
        FactoryGirl.build(:order, :state => "herp derp").should_not be_valid
    end

    it "is closed?" do
        FactoryGirl.create(:order, :state => "open").closed?.should be_false
    end

    it "is not closed?" do
        FactoryGirl.create(:order, :state => "closed").closed?.should be_true
    end

    it "is open?" do
        FactoryGirl.create(:order, :state => "open").open?.should be_true
    end

    it "is not open?" do
        FactoryGirl.create(:order, :state => "closed").open?.should be_false
    end


    context "empty order" do
        it "has a total of 0" do
            FactoryGirl.create(:order).total.should == 0
        end

        it "is empty" do
            FactoryGirl.create(:order).empty?.should be_true
        end

    end

    context "prints only" do
        before(:each) do
            @order = FactoryGirl.create(:order)

            @prints = [ FactoryGirl.create(:print, :price => 25), FactoryGirl.create(:print, :price => 5) ]
            @order.prints = @prints
            @order.save
        end

        context "small order" do
            it "has a total" do
                @order.total.to_i.should == 30
            end

            it "has a shipping cost"  do
                @order.shipping_cost.should_not be_zero
            end

            it "is not empty" do
                @order.empty?.should be_false
            end


        end

        context "large order" do
            it "has no shipping cost" do
                @order.prints << FactoryGirl.create(:print, :price => 55)
                @order.save

                @order.shipping_cost.should == 0
            end
        end
    end

    context "lessons only" do
    end

end

