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
    @art_show = Show.new(params[:show])

    if @art_show.save
      flash[:notice] = "Successfully created a new show."
      return redirect_to(schedule_path)
    end

    render :new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @art_show.update_attributes params[:show]
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
  def redirect_to_schedule_unless_admin
    redirect_to schedule_path unless admin?
  end

  def set_art_show
    @art_show = Show.find params[:id]
  end

  def delocalize_show_date
    params[:show][:date] = delocalize_time(params[:show][:date]) 
  end
end
