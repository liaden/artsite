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
            flash[:error] = "Error saving artwork"
            logger.debug "******* #{@artwork.errors["prints.material"]}\n#{@artwork.errors["prints.size_name"]}"
        end
        render :action => :new
    end

    def show
        @artwork = Artwork.find(params[:id])
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
        prints = []

        if params[:original_size]
            height, width = Print.height_and_width(params[:original_size])
            ratio = Float(height)/Float(width)

            # select option it is closer to: 3:4 or 2:3.
            ratio = ratio > 0.733333 ? "16x20" : "12:18"
        else
            flash[:error] = "No size specified."
        end

        if params[:enable_s]
            prints.append make_print("small", Print.ratio_to_small(ratio), "photopaper")
        end

        if params[:enable_m]
            prints.append make_print("medium", Print.ratio_to_medium(ratio), "photopaper")
            prints.append make_print("medium", Print.ratio_to_medium(ratio), "canvas")
        end

        if params[:enable_l]
            prints.append make_print("large", Print.ratio_to_large(ratio), "photopaper")
            prints.append make_print("large", Print.ratio_to_large(ratio), "canvas")
        end

        if params[:enable_xl]
            prints.append make_print("extra_large", Print.ratio_to_xlarge(ratio), "photopaper")
            prints.append make_print("extra_large", Print.ratio_to_xlarge(ratio), "canvas")
        end
        
        prints << Print.create(:price => params[:original_price], :size_name => "original", :material => "original", :dimensions => params[:original_size])
        
        @artwork.prints = prints
    end

    def make_print(size_name, dimensions, material)
        price = DefaultPrice.where(:dimension => dimensions, :material => material).first.price

        print = Print.create :price => price, :size_name => size_name, :material => material, :dimensions => dimensions
        if not print.valid?
            logger.debug "@@@@@@@#{size_name} #{dimensions} #{material} #{print.errors[:material]}"
        end
        print
    end
end
