class CartController < ApplicationController

    def purchase
        handled_guest_and_order_has_user?

        if params[:transaction_type] == 'lessons'
            purchase_lessons
        elsif params[:transaction_type] == 'artwork' 
            purchase_prints
        end
    end

    def index
       handled_guest_and_order_has_user?

       @order = active_order 
       @user = current_user
       @shipping = @order.shipping_cost
    end

    def checkout
        if handled_guest_and_order_has_user? 
            flash[:error] = "Error: Your order is associated with a user but you are not logged in. Please login, or refill your cart and place your order as a guest."
            redirect_to :action => :index
            return
        end

        @order = active_order
        @user = current_user

        if @order.user
            @order.user.address = Address.new unless @order.user.address
            @order.address = @order.user.address
            @order.save
        else
            @order.address = Address.new unless @order.address
        end
    end

    def receipt
        if handled_guest_and_order_has_user?
            flash[:error] = "Error in data. Order has not been placed."
            return redirect_to :action => :index
        end


        @order = active_order
        @stripe_card_token = params[:stripe_card_token]

        # nothing is being purchased...
        return redirect_to :action => :index unless @order and not @order.empty?

        address = Address.create params[:address]

        @base_amount = @order.total 
        @tax_amount =  0 #@base_amount * tax_rate # JOEL TODO
        @shipping_amount = @order.shipping_cost

        @total_amount = @base_amount + @tax_amount + @shipping_amount

        if not current_user
            @order.guest_email = params[:guest_email]
            @email = @order.guest_email
        else
            @email = current_user.email
        end

        logger.debug "amount is #{to_cents(@total_amount)}"
        charge = Stripe::Charge.create :amount => to_cents(@total_amount), :currency => "usd", :card => params[:stripe_card_token], :description => "#{@email}"

        if charge.paid
            @order.charge_id = charge.id
            @order.state = "closed"
            @order.placed_at = Time.now
            if @order.save
                if params[:send_email]
                    logger.debug "Sending email"
                    OrderMailer.order_receipt(@order)
                end
                OrderMailer.order_notification(@order)
            end
        else
            flash.now[:error] = "Error: #{charge.failure_message}"
        end
    end

    def remove
        return redirect_to :action => :index if handled_guest_and_order_has_user?

        @order = active_order

        @item_id = Integer(params[:id]) rescue "" 

        if params[:transaction_type] == 'class'
            remove_helper LessonOrder, @order.lessons
        elsif params[:transaction_type] == 'artwork'
            remove_helper PrintOrder, @order.prints
        else
            flash[:error] = "Did not recognize classification of item to be removed: #{params[:transaction_type]}"
        end

        @order.save

        redirect_to :action => :index
    end

    private

    def remove_helper(table, items)
        size = items.size

        table.delete_all ["print_id = ? and order_id = ?", @item_id, @order.id]

        flash[:error] = "Could not find item in cart to remove." if items.size == size
    end

    def purchase_lessons
    end

    def purchase_prints
        
        @order = active_order

        logger.debug "found id of: #{@order.id}"
    
        if params[:Size] =~ /\d+x\d+/
            if params[:item_id] =~ /\d+/
                if params[:material] == 'photopaper' or params[:material] == 'canvas' or params[:material] == 'original'
                    @print = Print.where :material => params[:material], :artwork_id => params[:item_id], :dimensions => params[:Size]
                    flash[:error] = "Could not find artwork with specified values" unless @print
                else
                    flash[:error] = "Invalid material for purchase."
                end
            else
                flash[:error] = "Invalid artwork specified."
            end
        else
            flash[:error] = "Invalid dimension specified."
        end

        if @print
            @order.prints << @print
            @order.save
        end

        # render gallery so they can shop some more
        @artworks = Artwork.all
        render 'artworks/index', :notice => 'Item has been added to the cart.'

    end

    def handled_guest_and_order_has_user?  
        if guest? and active_order.user
            order = Order.new
            session[:order] = order.id
        end
    end
end
