require 'spec_helper'

describe ApplicationController do
    context "as a guest" do
        before(:each) do
           activate_authlogic 
           @controller = ApplicationController.new
        end

        it "is a guest"  do
            @controller.should be_guest 
        end

        it "is not admin" do
            @controller.should_not be_admin
        end

        it "is not checking out" do
            @controller.should_not be_checking_out
        end

        # can't figure out how to test these so leave as pending
        it "has an open order"  do
            @order = FactoryGirl.create(:order)
            order_id = @order.id.to_s

            @controller.define_singleton_method :session do
                { :order => order_id } 
            end

            @controller.active_order.should == @order
        end

        it "creates an order" do
            session[:order] = nil

            @controller.define_singleton_method :session do 
                { :order => nil }
            end

            @controller.active_order.should be_an_instance_of(Order)
        end

        it "creates an order when old one is closed" do
            @order = FactoryGirl.create(:order, :state => 'closed')
            order_id = @order.id.to_s
            
            @controller.define_singleton_method :session do
                { :order => order_id } 
            end

            @controller.active_order.should_not == @order
        end
    end


    context "as a member" do
        before(:each) do
           activate_authlogic 
           @user = FactoryGirl.create(:user)
           UserSession.create(@user)
        end

        it "is not a guest" do
            ApplicationController.new.should_not be_guest
        end

        it "is not an admin" do
            ApplicationController.new.should_not be_admin
        end

        it "creates an active order" do
           ApplicationController.new.active_order.should_not be_nil
        end

        it "has an active order" do
            order = FactoryGirl.create(:order, :user => @user)
            ApplicationController.new.active_order.should eq(order)
        end

    end

    context "as an admin" do
        before(:each) do
           activate_authlogic 
           @user = FactoryGirl.create(:admin)
           UserSession.create(@user)
        end

        it "is not a guest" do
            ApplicationController.new.should_not be_guest
        end

        it "is an admin" do
            ApplicationController.new.should be_admin
        end
    end
end
