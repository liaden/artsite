class PagesController < ApplicationController
  before_filter :require_admin_or_send_home, :except => :show
  before_filter :get_page, :except => [:index, :new, :create]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      return redirect_to(:index, :notice => "#{page.type} #{name} has been published.")
    end

    render :new
  end

  def edit
  end

  def update
    if @page.update_attributes params[:page]
      redirect_to pages_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page.destroy
  end

private
  def get_page
    @page = Page.find_by_id(params[:id])
  end
end
