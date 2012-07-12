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

        # handle framing
        params.keys.grep(/.*framing/).each do |frame_key|
            print_id = frame_key.match(/\d+/)[0]

            flash.now[:error] = "Invalid framing options" unless print_id

            print_order = PrintOrder.find_by_print_id_and_order_id(print_id, @order.id)
            flash.now[:error] = "Could not find print order" unless print_order

            frame_type = params[frame_key]

            logger.debug "setting printorder with id = #{print_order.id} to frame_size #{frame_type}"

            if frame_type == "no_frame"
                print_order.frame_size = "no_frame"
                print_order.save
            else
                frame_size = "#{frame_type[0]}.#{frame_type[1..-1]}"

                # if we got something that can't be represented as a float, then we will have an exception
                begin
                    Float(frame_size)
                    print_order.frame_size = frame_size
                    print_order.save
                rescue 
                    flash[:error] = "frame size is not correctly formatted"
                end
            end
        end
        # done framing

        if @order.user
            @order.user.address = Address.create unless @order.user.address
            @order.address = @order.user.address
            @ord
        else
            @order.address = Address.create unless @order.address
        end
        @order.save
        render :action => :checkout
    end

    def verify_payment
        return checkout unless params[:stripe_card_token]

        logger.debug "we have #{Address.all.size} addresses in the table"

        if handled_guest_and_order_has_user?
            flash[:error] = "Error in data. Order has not been placed."
            return redirect_to :action => :index
        end


        @order = active_order
        @stripe_card_token = params[:stripe_card_token]

        # nothing is being purchased...
        return redirect_to :action => :index unless @order and not @order.empty?

        @order.address.update_attributes params[:address]
        @order.address.save
        
        if current_user
            if current_user.address
                current_user.address.update_attributes params[:address]
            else
                current_user.address = Address.create params[:address]
            end

            current_user.address.save
        end

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

        begin
        charge = Stripe::Charge.create :amount => to_cents(@total_amount), :currency => "usd", :card => params[:stripe_card_token], :description => "#{@email}"
        rescue => e
            flash[:error] = e.class == Stripe::CardError ? e.message : "An unexpected error has occurred"
            return render :action => :checkout
        end

        logger.debug "*** charge is #{charge}"

        if charge.card.cvc_check == "fail"
            flash[:cvc_error] = "Invalid CVC supplied."
        elsif  charge.card.address_zip_check == "fail"
            flash[:zip_error] = "Invalid zip code"
        elsif charge.card.address_line1_check == "fail"
            flash[:line1_error] = "Invalid address on line1"
        elsif not charge.paid
            flash[:error] = "Error: #{charge.failure_message}"
        else
            @order.charge_id = charge.id
            @order.state = "closed"
            @order.placed_at = Time.now
            if @order.save
                if params[:send_email]
                    logger.debug "Sending email"
                    OrderMailer.order_receipt(@order).deliver
                end
                OrderMailer.order_notification(@order).deliver
                return render :action => :receipt
            end
        end

        # one of the above checks failed so try again
        render :action => :checkout
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

    def checking_out?
        true
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
        if params[:material] == 'original' 
            @print = Print.where(:material => "original", :artwork_id => params[:item_id]).first
            flash.now[:error] = "Could not find original in database." unless @print
        elsif params[:size] =~ /\d+x\d+/
            if params[:item_id] =~ /\d+/
                if params[:material] == 'photopaper' or params[:material] == 'canvas' 
                    @print = Print.where(:material => params[:material], :artwork_id => params[:item_id], :dimensions => params[:size]).first
                    flash.now[:error] = "Could not find artwork with specified values" unless @print
                else
                    flash.now[:error] = "Invalid material for purchase."
                end
            else
                flash.now[:error] = "Invalid artwork specified."
            end
        else
            flash.now[:error] = "Invalid dimension specified."
        end

        if @print
            @order.prints << @print
            @order.save

            purchase_frame params[:framing]
            logger.debug "Added print #{@print.id} to cart."
        end

        # render gallery so they can shop some more
        @artworks = Artwork.find( :all, :order => "created_at DESC")
        render 'artworks/index', :notice => 'Item has been added to the cart.'

    end

    def handled_guest_and_order_has_user?
        if guest? and active_order.user
            logger.debug "Creating new order for guest that is not associated with a user.\n"
            order = Order.create
            session[:order] = order.id
        end
    end

    def purchase_frame(frame_size)
        logger.debug "***purchasing frame with size = #{frame_size}"

        return if @print.original?
        
        @print_order = PrintOrder.where(:print_id => @print.id, :order_id => @order.id).first
        if frame_size == "no_frame"
            @print_order.frame_size = "no_frame"
            @print_order.save
        else
            frame_size = "#{frame_size[0]}.#{frame_size[1..-1]}"
            logger.debug "reformatted to #{frame_size}"

            # if we got something that can't be represented as a float, then we will have an exception
            begin
                Float(frame_size)
                @print_order.frame_size = frame_size
                @print_order.save
            rescue 
                flash[:error] = "frame size is not correctly formatted"
            end
        end
    end
end
