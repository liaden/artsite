class UsersController < ApplicationController
    decorates_assigned :user

    def new
        @user = User.new
    end

    def create
        @user = User.new params[:user]

        # force everyone to be regular users
        @user.privilege = 0

        if @user.save
            redirect_to :controller => :main, :action => :index, :notice => "Account succusfully created."
        else
            render :action => :new
        end
    end

    def history
        @user = current_user
        @order = @user.old_orders.sorty_by { |order| order.placed_at }

        if not @user
            flash[:error] = "Please login to view this information."
        end
    end
end
