class UsersController < ApplicationController
  decorates_assigned :user

  def new
    @user = User.new
  end

  def create
    @user = User.new expected_user_params.merge(privilege: 0)

    User.transaction do
      @user.save!
      redirect_to home_path, :login_notice => "Account successfully created."
    end

  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def history
    @user = current_user
    @order = @user.old_orders.sorty_by { |order| order.placed_at }

    if not @user
      flash[:error] = "Please login to view this information."
    end
  end
private
  def expected_user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end
end
