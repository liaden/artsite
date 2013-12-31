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
            FactoryGirl.create :no_frame

            @order = FactoryGirl.create(:order)
            print_orders =  [ FactoryGirl.create(:print_order, :order => @order), FactoryGirl.create(:print_order, :order => @order) ]

            @prints = @order.prints

            @order.save
        end
        
        it "does not leave an orphan matte" do
            # production code should have this in a transaction so that if an rollback occurs,
            # the original matte would be restored, but I'd rather detect there is an error
            # because at this time I expect no rollbacks to be triggered in this case
            expect {
                # set things up like we are using objects normally
                @order = FactoryGirl.create :order, :prints => [ FactoryGirl.create(:print) ]
                
                # oh, let's change from unmatted to matted
                @print_order = @order.print_orders.first
                @print_order.matte = FactoryGirl.create :matte

                @print_order.save

            # is orphaned matte deleted?
            }.to change{ Matte.count }.by(0)
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

    context "lessons only" do
    end

end

