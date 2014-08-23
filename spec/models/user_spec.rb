require 'spec_helper'

describe User do
    it "can create a user" do
        FactoryGirl.create(:user).should be_valid
    end

    it "can create an admin" do
        FactoryGirl.create(:admin).should be_valid
    end

    it "has old orders" do
        old_orders = [ FactoryGirl.create(:closed_order), FactoryGirl.create(:closed_order) ]        
        user = FactoryGirl.create(:user)
        
        # add 2 closed orders and 1 open order
        user.orders = old_orders
        user.orders << FactoryGirl.create(:order)
        user.save

        user.old_orders.size.should == 2
    end

    it "has an active order" do
        order = FactoryGirl.create(:user_order)
        User.first.active_order.state.should == "open" 
    end

    it "creates an active order" do
        user = FactoryGirl.create(:user)
        user.create_active_order
        user.active_order.should be_valid
    end

    it "identifies admin as admin" do
        FactoryGirl.create(:admin).admin?.should be true
    end

    it "identifies visitor as not admin" do
        FactoryGirl.create(:user).admin?.should be false
    end
end
