class ShowsController < ApplicationController
  decorates_assigned :art_show

  before_filter :redirect_to_schedule_unless_admin, :except => :show
  before_filter :set_art_show, :except => [:new, :create]
  before_filter :delocalize_show_date, :only => [:create, :update]

  respond_to :html, :json

  def new
    @art_show = Show.new
  end

  def create
    Show.transaction do
      @art_show = Show.create!(admin_show_params)
      return redirect_to(schedule_path, :notice => "Successfully created a new show.")
    end

    render :new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @art_show.update_attributes admin_show_params
        format.html { redirect_to(@art_show, :notice => "The show #{@art_show.name} has been successfully updated.") }
        format.json { respond_with_bip(@art_show) }
      else
        format.html { render :action => 'edit' }
        format.json { respond_with_bip(@art_show) }
      end
    end
  end

  def destroy
    @art_show.destroy
  end

private
  def admin_show_params
    params.require(:show).permit(:name, :date, :building, :address, :show_type, :description)
  end

  def redirect_to_schedule_unless_admin
    redirect_to schedule_path unless admin?
  end

  def set_art_show
    @art_show = Show.find params[:id]
  end

  def delocalize_show_date
    # best in place editing will not always cause there to be a date attribute
    if params[:show][:date]
      params[:show][:date] = delocalize_time(params[:show][:date])
    end
  end
end
