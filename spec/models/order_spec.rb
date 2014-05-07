require 'spec_helper'

describe Order do
  before(:each) { mock_paperclip_post_process }

  it "fails on bad data" do
    FactoryGirl.build(:order, :state => "herp derp").should_not be_valid
  end

  it "is closed?" do
    FactoryGirl.create(:order, :state => "open").should_not be_closed
  end

  it "is not closed?" do
    FactoryGirl.create(:order, :state => "closed").should be_closed
  end

  it "is open?" do
    FactoryGirl.create(:order, :state => "open").should be_open
  end

  it "is not open?" do
    FactoryGirl.create(:order, :state => "closed").should_not be_open
  end


  context "empty order" do
    it "has a total of 0" do
      FactoryGirl.create(:order).total.should == 0
    end

    it "is empty" do
      FactoryGirl.create(:order).should be_empty
    end
  end

  context "with only prints" do
    before(:each) do
      @order = FactoryGirl.create(:order)
      print_orders =  [ FactoryGirl.create(:print_order, :order => @order), FactoryGirl.create(:print_order, :order => @order) ]

      @prints = @order.prints

      @order.save
    end
    
    context "small order" do
      it "has a total" do
        @order.total.to_i.should == 10
      end

      it "has a shipping cost"  do
        @order.shipping_cost.should_not be_zero
      end

      it "is not empty" do
        @order.should_not be_empty
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
end

