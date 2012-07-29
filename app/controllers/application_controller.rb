class ApplicationController < ActionController::Base
    protect_from_forgery
    
    def caller
        "ArchaicSmiles"
    end

    def checking_out?
        false
    end
    
    helper_method :current_user
    helper_method :admin?

    def guest?
        not current_user
    end

    def admin?
        current_user and current_user.admin?
    end

    private

    def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
    end

    def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
    end


    def active_order
        if current_user
            order = current_user.active_order
            order = current_user.create_active_order unless order
        else
            logger.debug "session is #{session}"
            # is order declared and is the order a number?
            if session[:order] and session[:order] =~ /\d+/
                order = Order.find_by_id session[:order]
            end

            # does this order exist in an open state?
            if not order or order.closed?
                logger.debug "Creating new open order"
                order = Order.create :state => 'open'
                session[:order] = String(order.id)
            end

        end

        return order
    end

    def to_cents(price)
        (price * 100).to_i
    end
    
end
