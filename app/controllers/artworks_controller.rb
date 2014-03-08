require 'twitter'
require 'tumblr4r'

class ArtworksController < ApplicationController
    decorates_assigned :artwork

    before_filter :require_admin, :only => [:new, :create, :edit, :update, :destroy ]
    before_filter :set_artwork, :only  => [:edit, :update, :show, :destroy ]

    def index
      @artworks = Artwork.find( :all, :order => "created_at DESC")
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
        @artwork.created_at = Date.strptime(params[:artwork][:created_at], '%m/%d/%Y') 

        if @artwork.save
          flash[:notice] = "'#{@artwork.title}' has been successfully created."
          return redirect_to(artwork_prints_path(@artwork))
        else
          flash.now[:error] = "Error saving artwork"
          logger.debug @artwork.errors.messages

          return render :action => :new
        end
      end

      render :action => :new
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
             format.json { respond_with_bip(@artwork) }
           else
             format.html { render :action => "edit" }
             format.json { respond_with_bip(@artwork) }
           end
         end
      end
    
    end

    def destroy
      return redirect_to :action => :index unless admin?

      Artwork.transaction do
          @artwork.destroy
      end

      @artworks = Artwork.all
      render :action => :index
    end

    def caller
      "Gallery"
    end

private
end
