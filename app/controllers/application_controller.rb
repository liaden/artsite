class ApplicationController < ActionController::Base
    protect_from_forgery

    def require_admin  
      redirect_to :action => :index unless admin?
    end

    def require_admin_or_send_home
      redirect_to home_path unless admin?
    end

    def set_artwork
      @artwork = Artwork.includes(:prints).find(params[:artwork_id] || params[:id])
    end

    def delocalize_time(value)
      result = DateTime.strptime(value, I18n.translate('date.formats.default'))
    end
    
    def caller
      "ArchaicSmiles"
    end

    def checking_out?
      false
    end
    
    helper_method :current_user
    helper_method :admin?
    helper_method :guest?
    helper_method :active_order
    helper_method :fullpath

    def guest?
      not current_user
    end

    def fullpath
      request.fullpath
    end

    def admin?
      current_user and current_user.admin?
    end

    def active_order
      if current_user
        order = current_user.active_order
        order = current_user.create_active_order unless order
      else
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


private

    def current_user_session
      @current_user_session = UserSession.find
    end

    def current_user
      @current_user = current_user_session && current_user_session.record
    end

    def to_cents(price)
      (price * 100).to_i
    end
end
