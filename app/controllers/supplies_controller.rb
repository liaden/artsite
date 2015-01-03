class SuppliesController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]
  before_filter :set_supply, :only => [:edit, :update, :destroy, :show]

  decorates_assigned :supply

  def index
    @supplies_by_category = Supply.order(:category).reduce({}) do |result, supply|
      result[supply.category] = result.fetch(supply.category, []) << supply.decorate
      result
    end
  end

  def new
    @supply = Supply.new
  end

  def create
    Supply.transaction do
      @supply = Supply.create!(admin_supply_params)
      return redirect_to(supply_path(@supply), :notice => "Successfully created #{@supply.name}")
    end

    render 'new'
  end

  def show
  end

  def edit
  end

  def update
    Supply.transaction do
      @supply.update_attributes! admin_supply_params
      return redirect_to(supply_path(@supply), :notice => "Successfully updated #{@supply.name}")
    end

    render 'edit'
  end

  def destroy
    if @supply.destroy
      return redirect_to(supplies_path, :notice => "Art supply has been successfully destroyed")
    end
  end

private

  def admin_supply_params
    params.require(:supply).permit(:name, :referral_url, :description, :category, :short_description)
  end

  def set_supply
    @supply = Supply.find(params[:id])
  end
end
