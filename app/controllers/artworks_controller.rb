require 'twitter'
require 'tumblr4r'
#require 'print_purchases'

class ArtworksController < ApplicationController


    before_filter :require_admin, :only => [:new, :create, :edit, :update, :destroy ]
    before_filter :set_artwork, :only  => [:edit, :update, :show, :destroy ]

    caches_action :index
    caches_action :show

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
        expire_action :action => :index

        ActiveRecord::Base.transaction do
            @artwork = Artwork.new params[:artwork] do |art|
                art.create_tags_from_csv params[:tags]
                art.create_medium_from_csv params[:mediums]
            end

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

        @artwork = @artwork.decorate
    end

    def edit
        @tags = @artwork.tags_csv
        @medium = @artwork.medium_csv
    end

    def update
        ActiveRecord::Base.transaction do
            
            @artwork.create_tags_from_csv params[:tags] if params[:tags]
            @artwork.create_medium_from_csv params[:medium] if params[:medium]
            @artwork.update_attributes(params[:artwork])

            if @artwork.valid?
                expire_action :action => :show
                return redirect_to @artwork
            end

            flash[:error] = @artwork.errors.messages 
            redirect_to edit_artwork_path(@artwork)
       end
    
    end

    def destroy
        return redirect_to :action => :index unless admin?

        Artwork.transaction do
            @artwork.destroy
            expire_action :action => :index
        end

        @artworks = Artwork.all
        render :action => :index
    end

    def caller
        "Gallery"
    end

private
end
