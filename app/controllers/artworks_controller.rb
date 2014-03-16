require 'twitter'
require 'tumblr4r'

class ArtworksController < ApplicationController
  decorates_assigned :artwork

  before_filter :require_admin, :only => [:new, :create, :edit, :update, :destroy ]
  before_filter :set_artwork, :only  => [:edit, :update, :show, :destroy ]

  respond_to :html, :json

  def index
    @category = 'Featured'
    @artworks = Artwork.featured( :order => "created_at DESC") || []
  end

  def new
    @artwork = Artwork.new
    @tags = ""
    @mediums = ""

    # defaults sizes for a 2:3 ratio
    @sizes = [ '4x6', '8x12', '12x18' ]
  end

  def create
    ActiveRecord::Base.transaction do
      @artwork = Artwork.new params[:artwork] do |art|
        art.create_tags_from_csv params[:tags]
        art.create_medium_from_csv params[:mediums]
      end

      if params[:artwork][:created_at]
        @artwork.created =  params[:artwork][:created_at]
      end

      @artwork.save!

      flash[:notice] = "'#{@artwork.title}' has been successfully created."
      return redirect_to(artwork_prints_path(@artwork))
    end

    flash.now[:error] = "Error saving artwork"
    logger.debug @artwork.errors.messages

    return render :action => :new
  end

  def show
    if request.path != artwork_path(@artwork)
      redirect_to @artwork, :status => :moved_permanently
    end

    impressionist(@artwork)
  end

  def edit
    @tags = @artwork.tags_csv
    @medium = @artwork.medium_csv
  end

  def update
    ActiveRecord::Base.transaction do
      
      @artwork.create_tags_from_csv params[:tags] if params[:tags]
      @artwork.create_medium_from_csv params[:medium] if params[:medium]

      respond_to do |format|
        if @artwork.update_attributes(params[:artwork])
          format.html { redirect_to(@artwork, :notice => "Artwork #{@artwork.title} has been successfully updated.") }
          format.json do
            if params[:bip] == 'skip'
              respond_with @artwork.to_json
           else
             respond_with_bip(@artwork) 
           end
          end
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@artwork) }
        end
      end
    end
  end

  def filter_by_category
    categories = %w(All Featured Fanart)
    @category = params[:category] || 'Featured'

    if @category.match /^\d\d\d\d$/
      @artworks = Artwork.for_year(@category)
    elsif categories.any? { |category| category == @category  }
      @artworks = Artwork.send(@category.downcase, :order => 'created_at DESC') 
    else
      tag = Tag.find_by_name(@category)
      @artworks = tag.artworks if tag
    end

    @artworks ||= []

    render :index
  end

  def destroy
    return redirect_to :action => :index unless admin?

    Artwork.transaction do
      @artwork.destroy
    end

    @artworks = Artwork.all

    respond_to do |format|
      format.html { redirect_to artworks_path }
      format.json { respond_with {} }
    end
  end

  def caller
    "Gallery"
  end

private
  def artworks
    @decorated_artworks ||= ArtworksDecorator.decorate(@artworks, :context => { :category => @category } )
  end

  helper_method :artworks
end
