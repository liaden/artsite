class PrintsController < ApplicationController
  before_filter :redirect_to_root_unless_admin, :set_artwork
  before_filter :set_print, :except => [ :index, :new, :canvas, :photopaper, :original, :create ]

  decorates_assigned :print

  respond_to :html, :json

  def index
    @prints = @artwork.prints
  end

  def new
    @print = Print.new :material => params.fetch(:material, :photopaper)
    respond_with @print
  end

  def canvas
    @print = Print.canvas :artwork => @artwork
    render :action => :new
  end

  def photopaper
    @print = Print.photopaper :artwork => @artwork
    render :action => :new
  end

  def original
    @print = Print.original :artwork => @artwork
    render :action => :new
  end

  def show
  end

  def create
    @print = Print.new params[:print].merge(:artwork => @artwork)

    if @print.save
      flash[:notice] = "Created new print!"

      return render :action => :show, :layout => params[:ajax].nil?
    end

    render 'errors', :head => :unprocessable_entity
  end

  def edit
  end

  def update
    @print.update_attributes params[:print]
    if @print.valid?
      expire_action :controller => :artwork, :action => :show, :id => @artwork.id
      flash[:notice] = "Updated the print"

      return redirect_to edit_artwork_path(@print.artwork)
     end

    flash.now[:error] = 'Error: could not update print'
    render :action => :edit
  end

  def destroy
    @print.destroy
    render :action => :index
  end

private
  def redirect_to_root_unless_admin
    redirect_to home_path unless admin?
  end

  def set_print
    @print = Print.find params[:id]
  end
end
