require 'twitter'
require 'tumblr4r'

class ArtworksController < ApplicationController
    def index
        @artworks = Artwork.all
    end

    def new
        return redirect_to :action => :index unless admin?

        @artwork = Artwork.new
        @tags = ""
        @mediums = ""

        # defaults sizes for a 2:3 ratio
        @sizes = [ '4x6', '8x12', '12x18' ]
        
    end

    def create
        return redirect_to :action => :index unless admin?

        @artwork = Artwork.new(params[:artwork])
        logger.debug params

        set_tags
        set_medium
        set_prints
       
        if @artwork.save
            flash.now[:notice] = "'#{@artwork.title}' has been successfully created."
        else
            flash[:error] = "Error in creating new artwork."
        end
        render :action => :new
    end

    def show
        @artwork = Artwork.find_by_id(params[:id])
    end

    def edit
        return redirect_to :action => :index unless admin?

        @artwork = Artwork.find_by_id(params[:id])
        @tags = @artwork.tags * ","
        #@tags = @artwork.tags.reduce { |a,b| "#{a.name},#{b.name}" }
        @medium = @artwork.medium * ","
        #@medium = @artwork.medium.reduce { |a,b| "#{a.name},#{b.name}" }
        @sizes = @artwork.sizes
    end

    def update
        return redirect_to :action => :index unless admin?

        preprocess_prices
        @artwork = Artwork.where(:id => params[:id]).first

        set_tags
        set_medium
    end

    def destroy
    end

    def caller
        "Gallery"
    end

    private

    def set_tags
        @artwork.tags = []
        params[:tags].split(',').each do |tag_name|
            tag = Tag.find_or_create_by_name tag_name
            @artwork.tags << tag
        end
    end

    def set_medium
        @artwork.medium = []
        params[:mediums].split(',').each do |media_name|
            media = Medium.find_or_create_by_name media_name
            @artwork.medium << media
        end
    end

    def set_prints
        prints = make_prints("small") << make_prints("medium") << make_prints("large")
        
        prints << Print.new(:price => params[:original_price], :size_name => "", :material => :original, :dimensions => params[:original_size])
        prints.each { |print| print.save }
        
        @artwork.prints = prints
    end

    def make_print(size_name)
        p1 = Print.new :price => params["#{size_name}_price"], :size_name => size_name, :material => :photopaper, :dimensions => params["#{size_name}_size"]
        p2 = Print.new :price => params["#{size_name}_canvas_price"], :size_name => size_name, :material => :canvas, :dimensions => params["#{size_name}_size"]
        [ p1, p2 ]
    end
end
