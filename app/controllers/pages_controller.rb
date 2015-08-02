class PagesController < ApplicationController
  before_filter :require_admin_or_send_home, :except => [ :show, :index ]
  before_filter :get_page, :except => [:index, :new, :create]

  respond_to :html, :json

  decorates_assigned :page

  def index
    @videos = Page.where(:page_type => :video).order('created_at DESC')
    @tutorials = Page.where(:page_type => :tutorial).order('created_at DESC')
  end

  def tutorials
    @pages = Page.where(:page_type => :tutorial)
    render :index
  end

  def videos
    @pages = Page.where(:page_type => :video)
    render :index
  end

  def show
    respond_with @page
  end

  def new
    @page = Page.new
  end

  def create
    Page.transaction do
      @page = Page.create!(admin_page_params)
      return redirect_to(@page, :notice => "#{page.page_type} #{page.name} has been published.")
    end

  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
  end

  def update
    Page.transaction do
      @page.update_attributes! admin_page_params
      return redirect_to @page, :notice => "Successfully updated #{page.name}"
    end

  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def destroy
    @page.destroy

    redirect_to pages_path, :notice => "Successfully deleted page"
  end
  helper_method :videos, :tutorials

private

  def admin_page_params
    params.require(:page).permit(:name, :page_type, :content)
  end

  def videos
    @decorated_videos ||= PageDecorator.decorate_collection(@videos)
  end

  def tutorials
    @decorated_tutorials ||= PageDecorator.decorate_collection(@tutorials)
  end

  def get_page
    @page = Page.find(params[:id])
  end
end
