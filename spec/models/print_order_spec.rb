require 'spec_helper'

describe PrintOrder do
  before(:each) { mock_paperclip_post_process }

  before(:each) do
    @five_by_seven = FactoryGirl.create(:print, :dimensions => "5x7")
    @original = FactoryGirl.create(:original, :dimensions => "5x7", :price => 5)
  end

  it "is has an order and a print" do
    order = FactoryGirl.build :print_order, :order => nil, :print => nil
    order.should be_invalid
    order.errors.count.should == 2
  end

  context "has a price" do
    it "is 5x7 with no frame" do
      print_order = FactoryGirl.create :print_order, :print => @five_by_seven
      print_order.price.should == 5.0
    end
  end
end
