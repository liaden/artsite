class PagesController < ApplicationController
  before_filter :require_admin_or_send_home, :except => [ :show, :index ]
  before_filter :get_page, :except => [:index, :new, :create]

  respond_to :html, :json

  decorates_assigned :page
  decorates_assigned :pages

  def index
    @pages = Page.all.order('created_at DESC')

    respond_with @pages
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
    @page = Page.new(params[:page])

    if @page.save
      return redirect_to(@page, :notice => "#{page.page_type} #{page.name} has been published.")
    end

    render :new
  end

  def edit
  end

  def update
    if @page.update_attributes params[:page]
      redirect_to @page, :notice => "Successfully updated #{page.name}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page.destroy

    redirect_to pages_path, :notice => "Successfully deleted page"
  end

private
  def get_page
    @page = Page.find_by_id(params[:id])
  end
end
