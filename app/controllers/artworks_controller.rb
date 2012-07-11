require 'twitter'
require 'tumblr4r'

class ArtworksController < ApplicationController

    caches_action :index
    caches_action :show

    def index
        @artworks = Artwork.find( :all, :order => "created_at DESC")
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

        expire_action :action => :index

        @artwork = Artwork.new(params[:artwork])

        if set_prints
            set_tags
            set_medium

            if @artwork.save
                flash.now[:notice] = "'#{@artwork.title}' has been successfully created."
            else
                flash.now[:error] = "Error saving artwork"
            end

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
        @medium = @artwork.medium * ","
        
        @sizes = @artwork.sizes
    end

    def update
        return redirect_to :action => :index unless admin?
        
        expire_action :action => :index

        @artwork = Artwork.find(:params[:id])

        set_tags
        set_medium
    end

    def destroy
        return redirect_to :action => :index unless admin?
        
        expire_action :action => :index
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
            begin
                height, width = Print.height_and_width(params[:original_size])
                ratio = Float(height)/Float(width)
            rescue
                flash.now[:error] = "Invalid size specified for artwork"
                return false
            end

            # select option it is closer to: 3:4 or 2:3.
            ratio = ratio > 0.733333 ? "16x20" : "12:18"
        else
            flash.now[:error] = "No size specified."
        end

        if params[:enable_s]
            make_print("small", Print.ratio_to_small(ratio), "photopaper", prints)
        end

        if params[:enable_m]
            make_print("medium", Print.ratio_to_medium(ratio), "photopaper", prints)
            make_print("medium", Print.ratio_to_medium(ratio), "canvas", prints)
        end

        if params[:enable_l]
            make_print("large", Print.ratio_to_large(ratio), "photopaper", prints)
            make_print("large", Print.ratio_to_large(ratio), "canvas", prints)
        end

        if params[:enable_xl]
            make_print("extra_large", Print.ratio_to_xlarge(ratio), "photopaper", prints)
            make_print("extra_large", Print.ratio_to_xlarge(ratio), "canvas", prints)
        end
        
        prints << Print.create(:price => params[:original_price], :size_name => "original", :material => "original", :dimensions => params[:original_size])
        
        @artwork.prints = prints

        return true
    end

    def make_print(size_name, dimensions, material, prints)
        price = DefaultPrice.where(:dimension => dimensions, :material => material).first
        
        if not price
            flash.now[:config_error] = "Default price has not been set for this material and dimension combination" unless price
            return false
        end

        print = Print.create :price => price.price, :size_name => size_name, :material => material, :dimensions => dimensions
        prints.append print

        return true
    end
end
