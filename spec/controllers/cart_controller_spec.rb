require 'spec_helper'
require 'stripe'
require 'stripe_mock'

describe CartController do
    #context "as a guest" do
    #    context "GET #index" do
    #        context "has an empty cart" do
    #            it "has no shipping cost" do
    #                get :index
    #                assigns(:shipping).should == 0
    #            end

    #            it "creates a new order for guest" do
    #                get :index
    #                Order.all.size.should == 1
    #            end
    #            
    #            it "shows same order" do
    #                get :index
    #                get :index
    #                Order.all.size.should == 1
    #            end

    #            it "has an empty order" do
    #                get :index
    #                Order.first.prints.should be_empty
    #            end
    #        end

    #        context "has items in cart" do
    #            before(:each) do
    #                get :index
    #                @order = Order.first
    #                @order.prints = [ FactoryGirl.create(:print) ]
    #                @order.save
    #            end

    #            it "assigns an order" do
    #                get :index
    #                assigns(:shipping).should == 5
    #            end

    #            it "assigns nil user"  do
    #                get :index
    #                assigns(:user).should be_nil
    #            end

    #            it "assigns shipping" do
    #                get :index
    #                assigns(:shipping).should == 5
    #            end

    #            it "has no shipping when over $50"  do
    #                @order.prints << FactoryGirl.create(:print, :price => 50)
    #                @order.save

    #                get :index
    #                assigns(:shipping).should == 0
    #            end
    #        end
    #    end

    #    context "PUT #purchase" do
    #        it "adds first item to order" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => @print.dimensions, :framing => "200"
    #            Order.first.prints.should_not be_empty
    #        end
    #        it "adds second item to order" do
    #            @print1 = FactoryGirl.create :print
    #            @print2 = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print1.material, :item_id => @print1.artwork.id, :size => @print1.dimensions, :framing => "200"
    #            put :purchase, :transaction_type => 'artwork', :material => @print2.material, :item_id => @print2.artwork.id, :size => @print2.dimensions, :framing => "200"
    #            Order.first.prints.size.should == 2
    #        end
    #    end

    #    context "GET #remove" do
    #        before(:each) do
    #            @order = FactoryGirl.create( :order, :user => @user, :prints => [ FactoryGirl.create(:print) ] )
    #            @print = @order.prints.first
    #            session[:order] = @order.id.to_s
    #        end

    #        it "removes item from order" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id
    #            @order.reload.prints.should be_empty
    #        end

    #        it "warns for nonexistant item" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id + 1
    #            flash[:error].should_not be_empty
    #        end
    #    end

    #    context "POST #checkout" do
    #    end

    #    context "POST #verify_payment" do
    #        before(:each) do 
    #            @attrs = { :stripe_card_token => "fake_stripe_token",
    #                      :address => FactoryGirl.attributes_for(:address),
    #                      :guest_email => Faker::Internet.email
    #            }

    #            @mock_card_attrs = { :cvc_check => "pass", :address_zip_check => "pass", :address_line1_check => "pass" }

    #            mock_card = MockCard.new @mock_card_attrs
    #            mock_charge = MockCharge.new :card => mock_card, :paid => true, :id => "1"

    #            Stripe::Charge.use_create_return_value  mock_charge
    #        end

    #        it "redirects without stripe token" do
    #            post :verify_payment
    #            response.should redirect_to(checkout_path)
    #        end

    #        it "has no order" do
    #            post :verify_payment, :stripe_card_token => "fake_stripe_token"
    #            response.should redirect_to(cart_path)
    #        end

    #        context "with an order" do
    #            before(:each) do
    #                @order = FactoryGirl.create( :order, :user => @user, :prints => [ FactoryGirl.create(:print, :price => 5.0) ] )
    #                @print = @order.prints.first
    #                session[:order] = @order.id.to_s
    #            end

    #            it "works without guest email" do
    #                @attrs[:guest_email] = nil
    #                post :verify_payment, @attrs
    #            end

    #            it "is taxed in alabama" do
    #                @attrs[:address] = FactoryGirl.attributes_for(:alabama_address)
    #                post :verify_payment, @attrs
    #                assigns(:tax_amount).should > 0.0
    #            end

    #            it "is not in alabama" do
    #                @attrs[:address] = FactoryGirl.attributes_for(:address, :state => "OH")
    #                post :verify_payment, @attrs
    #                assigns(:tax_amount).should == 0.0
    #            end

    #            it "assigns base amount" do
    #                post :verify_payment, @attrs
    #                assigns(:base_amount).should_not be_nil
    #            end

    #            it "assigns total_amount" do
    #                post :verify_payment, @attrs
    #                assigns(:total_amount).should > 0.0
    #            end

    #            it "assigns shipping amount" do
    #                post :verify_payment, @attrs
    #                assigns(:shipping_amount).should > 0.0
    #            end

    #            it "sends an email" do
    #                @attrs[:send_email] = "yes"
    #                post :verify_payment, @attrs
    #            end

    #            it "closes the order" do
    #                post :verify_payment, @attrs
    #                @order.reload.state.should == "closed"
    #            end

    #            it "increments sold count on items" do
    #                post :verify_payment, @attrs
    #                @order.reload.prints.first.sold_count.should == 1
    #            end

    #            it "stores the charge id" do
    #                post :verify_payment, @attrs
    #                @order.reload.charge_id.should_not be_nil
    #            end

    #            it "handles bad cvc" do
    #                @mock_card_attrs[:cvc_check] = "fail"
    #                Stripe::Charge.use_create_return_value MockCharge.new(:id => 1, :paid => true, :card => MockCard.new(@mock_card_attrs))

    #                post :verify_payment, @attrs
    #                flash[:cvc_error].should_not be_empty
    #            end

    #            it "handles bad zipcode" do
    #                @mock_card_attrs[:address_zip_check] = "fail"
    #                Stripe::Charge.use_create_return_value(MockCharge.new :id => 1, :paid => true, :card => MockCard.new(@mock_card_attrs))

    #                post :verify_payment, @attrs
    #                flash[:zip_error].should_not be_empty
    #            end

    #            it "handles bad address" do
    #                @mock_card_attrs[:address_line1_check] = "fail"
    #                Stripe::Charge.use_create_return_value MockCharge.new(:id => 1, :paid => true, :card => MockCard.new(@mock_card_attrs))

    #                post :verify_payment, @attrs
    #                flash[:line1_error].should_not be_empty
    #            end

    #            it "handles unpaid charge" do
    #                Stripe::Charge.use_create_return_value MockCharge.new :id => 1, :paid => false, :failure_message => "Test mocking failure", :card => MockCard.new(@mock_card_attrs)

    #                post :verify_payment, @attrs
    #                flash[:error].should_not be_empty
    #            end

    #            it "handles CardError"
    #        end
    #    end
    #end

    #context "as a member" do
    #    before(:each) do
    #        activate_authlogic
    #        @user = FactoryGirl.create(:user)
    #        UserSession.create(@user)
    #    end

    #    context "GET #index" do
    #        it "assigns user" do
    #            get :index
    #            assigns(:user).should == @user
    #        end

    #        it "creates an order for the user" do
    #            get :index
    #            Order.all.size.should == 1
    #        end

    #        it "creates a new open order when old one is closed" do
    #            @user.orders << FactoryGirl.create(:closed_order)
    #            @user.save

    #            get :index
    #            Order.all.size.should == 2
    #        end
    #    end

    #    context "PUT #remove" do
    #        before(:each) do
    #            @order = FactoryGirl.create( :order, :user => @user, :prints => [ FactoryGirl.create(:print) ] )
    #            @print = @order.prints.first
    #        end

    #        it "removes item from order" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id
    #            @order.reload.prints.should be_empty
    #        end

    #        it "warns for nonexistant item" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id + 1
    #            flash[:error].should_not be_empty
    #        end
    #    end

    #    context "PUT #purchase" do
    #        
    #        context "for an original" do
    #            it "is on show" do
    #                @print = FactoryGirl.create(:original, :is_on_show => true)                                        
    #                put :purchase, :item_id => @print.artwork.id, :material => @print.material, :transaction_type => 'artwork'
    #                flash[:error].should_not be_empty
    #            end

    #            it "is soldout" do
    #                @print = FactoryGirl.create(:original, :is_sold_out => true)
    #                put :purchase, :item_id => @print.artwork.id, :material => @print.material, :transaction_type => 'artwork'
    #                flash[:error].should_not be_empty
    #            end

    #            it "does not exist" do
    #                @print = FactoryGirl.create(:original)
    #                put :purchase, :item_id => @print.artwork.id+1, :material => @print.material, :transaction_type => 'artwork'
    #                flash[:error].should_not be_empty
    #            end

    #            it "is available" do
    #                @print = FactoryGirl.create(:original)
    #                put :purchase, :item_id => @print.artwork.id, :material => @print.material, :transaction_type => 'artwork'
    #                Order.first.prints.should_not be_empty
    #            end
    #        end

    #        it "purchases canvas" do
    #            @print = FactoryGirl.create :canvas
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => @print.dimensions, :framing => "no_frame"
    #            Order.first.prints.should_not be_empty  
    #        end

    #        it "purchases photopaper" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => @print.dimensions, :framing => "no_frame"
    #            Order.first.prints.should_not be_empty  
    #        end

    #        it "adds to print list" do
    #            @print1 = FactoryGirl.create :print
    #            @print2 = FactoryGirl.create :print
    #            FactoryGirl.create(:order, :user => @user, :prints => [@print1])
    #            put :purchase, :transaction_type => 'artwork', :material => @print2.material, :item_id => @print2.artwork.id, :size => @print2.dimensions, :framing => "no_frame"
    #            
    #            Order.first.prints.size.should == 2
    #        end

    #        it "includes a frame" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => @print.dimensions, :framing => "200"
    #            Order.first.prints.should_not be_empty  
    #        end

    #        it "has an invalid frame size" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => @print.dimensions, :framing => "abcd"
    #            Order.first.prints.should_not be_empty  
    #        end

    #        it "invalid dimension" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => "abcd"
    #            flash[:error].should_not be_empty    
    #        end

    #        it "could not find artwork" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => @print.artwork.id, :size => "0x0"
    #            flash[:error].should_not be_empty
    #        end

    #        it "unknown artwork" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => @print.material, :item_id => "abcd", :size => "0x0"
    #            flash[:error].should_not be_empty
    #        end

    #        it "invalid material" do
    #            @print = FactoryGirl.create :print
    #            put :purchase, :transaction_type => 'artwork', :material => 'abcd', :item_id => @print.artwork.id, :size => @print.dimensions
    #            flash[:error].should_not be_empty
    #        end

    #        it "redirects when there is no transaction type" do
    #            put :purchase
    #            response.should redirect_to(artworks_path)
    #        end

    #        context "after signing out" do
    #            it "creates new cart when called" do
    #                @print1 = FactoryGirl.create :print
    #                @print2 = FactoryGirl.create :print

    #                put :purchase, :transaction_type => 'artwork', :material => @print1.material, :item_id => @print1.artwork.id, :size => @print1.dimensions, :framing => "no_frame"

    #                # signing user out
    #                UserSession.find.destroy

    #                put :purchase, :transaction_type => 'artwork', :material => @print2.material, :item_id => @print2.artwork.id, :size => @print2.dimensions, :framing => "no_frame"

    #                Order.all.size.should == 2
    #            end
    #        end
    #    end

    #    context "GET #remove" do
    #        before(:each) do
    #            @order = FactoryGirl.create( :order, :user => @user, :prints => [ FactoryGirl.create(:print) ] )
    #            @print = @order.prints.first
    #        end

    #        it "removes item from order" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id
    #            @order.reload.prints.should be_empty
    #        end

    #        it "warns for nonexistant item" do
    #            get :remove, :transaction_type => 'artwork', :id => @print.id + 1
    #            flash[:error].should_not be_empty
    #        end

    #    end

    #    context "POST #checkout" do
    #    end

    #    context "POST #verify_payment" do
    #        before(:each) do

    #            @attrs = { :stripe_card_token => "fake_stripe_token",
    #                      :address => FactoryGirl.attributes_for(:address)
    #            }

    #            @mock_card_attrs = { :cvc_check => "pass", :address_zip_check => "pass", :address_line1_check => "pass" }

    #            mock_card = MockCard.new @mock_card_attrs
    #            mock_charge = MockCharge.new :card => mock_card, :paid => true, :id => "1"

    #            Stripe::Charge.use_create_return_value  mock_charge

    #            @order = FactoryGirl.create( :order, :user => @user, :prints => [ FactoryGirl.create(:print, :price => 5.0) ] )
    #            @print = @order.prints.first

    #        end

    #        it "closes the order" do
    #            post :verify_payment, @attrs
    #            @order.reload.state.should == "closed"
    #        end

    #        it "updates the address" do
    #            @user.address = FactoryGirl.create(:address)
    #            @user.save

    #            post :verify_payment, @attrs
    #            @order.reload.address.attributes.should_not == @attrs[:address]
    #        end

    #        it "ignores guest email" do
    #            @attrs[:guest_email] = "abcd@meh.com"

    #            post :verify_payment, @attrs
    #            @user.email.should_not == @attrs[:guest_email]
    #        end

    #        it "sends to users email and not guest email" do
    #            @attrs[:guest_email] = "abcd@meh.com"

    #            post :verify_payment, @attrs
    #            assigns(:email).should_not == @attrs[:guest_email]
    #        end
    #    end
    #end

end

