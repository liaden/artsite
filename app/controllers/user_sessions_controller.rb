class UserSessionsController < ApplicationController
    decorates_assigned :user_session

    def new
        @user_session = UserSession.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @user_session }
        end
    end

    def create
        @user_session = UserSession.new(params[:user_session])

        respond_to do |format|
            if @user_session.save
                
                migrate_cart
                flash[:notice] = "Login successful"

                format.html { redirect_to(:controller => :main, :action => :index ) }
                format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
            end
        end
    end 

    def destroy
        @user_session = UserSession.find
        @user_session.destroy

        session[:order] = nil

        respond_to do |format|
            flash[:notice] = 'Goodbye!'
            format.html { redirect_to(:login) }
            format.xml  { head :ok }
        end
    end

    private

    def migrate_cart
        # did user add things to a cart while checked out
        logger.debug "session is #{session}"
        if session[:order]
            order = Order.find_by_id(Integer(session[:order]))
            return unless order

            # no items in order so clean up and exit
            if order.empty? 
                order.delete
                return
            end

            user = current_user

            # delete previous active order
            if user.active_order
                user.active_order.delete
            end

            # set order to what they added while signed out
            user.orders << Order.find_by_id(Integer(session[:order]))
        end
    end
end   
