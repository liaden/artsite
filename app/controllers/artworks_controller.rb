require 'twitter'
require 'tumblr4r'

class ArtworksController < ApplicationController
  decorates_assigned :artwork

  before_filter :require_admin, :only => [:new, :create, :edit, :update, :destroy ]
  before_filter :set_artwork, :only  => [:edit, :update, :show, :destroy ]

  respond_to :html, :json

  def index
    @category = ArtworkCategory.new('Featured')
    @artworks = Artwork.featured.order("created_at DESC") || []
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
      @artwork = Artwork.new expected_artwork_params do |art|
        art.create_tags_from_csv params[:tags]
        art.create_medium_from_csv params[:mediums]
      end

      if params[:artwork][:created_at]
        @artwork.created =  params[:artwork][:created_at]
      end

      @artwork.save!

      redirect_to(artwork_prints_path(@artwork), 
        :notice => "'#{@artwork.title}' has been successfully created.")
    end

  rescue ActiveRecord::RecordInvalid
    logger.debug @artwork.errors.messages

    render :action => :new
  end

  def show
    if request.path != artwork_path(@artwork)
      redirect_to @artwork, :status => :moved_permanently
    end
  end

  def edit
    @tags = @artwork.tags_csv
    @medium = @artwork.medium_csv
  end

  def update
    ActiveRecord::Base.transaction do
      successful =  @artwork.update_attributes(expected_artwork_params).tap do
        @artwork.create_tags_from_csv params[:tags] 
        @artwork.create_medium_from_csv params[:medium] 
      end

      respond_to do |format|
        format.html { html_response(successful) }
        format.json { json_response(successful) }
      end

      raise ActiveRecord::Rolback unless successful
    end
  end

  def filter_by_category
    @category = ArtworkCategory.new(params[:category])

    if @category.year? 
      @artworks = Artwork.for_year(@category.name)
    elsif @category.predefined?
      @artworks = Artwork.send(@category.name.downcase).order('created_at DESC') 
    else
      tag = Tag.find_by_name(@category.name)
      @artworks = tag.artworks if tag
    end

    @artworks ||= []

    render :index
  end

  def destroy
    Artwork.transaction do
      @artwork.destroy
    end

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
    @decorated_artworks ||= ArtworksDecorator.decorate(@artworks, :context => { :category => @category.name } )
  end

  def expected_artwork_params
    params.require(:artwork).permit(:title, :description, :image)
  end

  def html_response(success)
    if success
      redirect_to(@artwork, :notice => "Artwork #{@artwork.title} has been successfully updated.") 
    else
      render :action => 'edit'
    end
  end

  def json_response(success)
    if success and params[:bip] == 'skip'
      respond_with @artwork.to_json
    else
      respond_with_bip(@artwork)
    end
  end

  helper_method :artworks
end
