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

        ActiveRecord::Base.transaction do
            @artwork = Artwork.create(params[:artwork])

            set_prints
            set_tags
            set_medium

            if @artwork.save
                flash.now[:notice] = "'#{@artwork.title}' has been successfully created."
            else
                flash.now[:error] = "Error saving artwork"
                puts @artwork.errors.messages
                logger.debug @artwork.errors.messages
            end
        end

        @artwork = Artwork.new
        render :action => :new
    end

    def show
        @artwork = Artwork.find(params[:id])

        if request.path != artwork_path(@artwork)
            redirect_to @artwork, :status => :moved_permanently
        end
    end

    def edit
        return redirect_to :action => :index unless admin?

        @artwork = Artwork.find(params[:id])

        @tags = @artwork.tags.map { |t| t.name } * ","
        @medium = @artwork.medium.map { |m| m.name } * ","
        
        @sizes = @artwork.sizes
    end

    def update
        return redirect_to :action => :index unless admin?

        ActiveRecord::Base.transaction do
            expire_action :action => :index
            @artwork = Artwork.find(params[:id])
            
            @original = @artwork.original
            params[:original_size] = @original.dimensions            
            
            set_tags
            set_medium

            if @artwork.update_attributes params[:artwork]

                begin
                    set_prints
                rescue => e
                    puts e.inspect
                end

                @original.price = params[:original_price]
                @original.is_sold_out = params[:is_sold_out] != nil

                @original.save
                @artwork.save
            end
        end

    
        unless @artwork.valid?
            flash[:error] = @artwork.errors.messages 

            return redirect_to edit_artwork_path(@artwork)
        end

        redirect_to @artwork

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
            tag = Tag.find_or_create_by_name tag_name.strip
            @artwork.tags << tag
        end
    end

    def set_medium
        @artwork.medium = []
        params[:mediums].split(',').each do |media_name|
            media = Medium.find_or_create_by_name media_name.strip
            @artwork.medium << media
        end
    end

    def set_prints
        prints = []

        if params[:original_size]
            begin
                dimensions = Print.height_width(params[:original_size])
                ratio = Float(dimensions[:height])/Float(dimensions[:width])
            rescue
                flash.now[:error] = "Invalid size specified for artwork"
                raise ActiveRecord::Rollback.new "Invalid size specified for artwork"
            end
        else
            flash.now[:error] = "No size specified."
        end

        if params[:enable_s]
            make_print("small", Print.ratio_to_small(ratio), "photopaper", @artwork)
        end

        if params[:enable_m]
            make_print("medium", Print.ratio_to_medium(ratio), "photopaper", @artwork)
            make_print("medium", Print.ratio_to_medium(ratio), "canvas", @artwork)
        end

        if params[:enable_l]
            make_print("large", Print.ratio_to_large(ratio), "photopaper", @artwork)
            make_print("large", Print.ratio_to_large(ratio), "canvas", @artwork)
        end

        if params[:enable_xl]
            make_print("extra_large", Print.ratio_to_xlarge(ratio), "photopaper", @artwork )
            make_print("extra_large", Print.ratio_to_xlarge(ratio), "canvas", @artwork)
        end
        
        if not @artwork.original
            is_sold_out = params[:is_sold_out] != nil
            @artwork.prints << Print.create(:price => params[:original_price], :size_name => "original", :material => "original", :dimensions => params[:original_size], :is_sold_out => is_sold_out, :inventory_count => is_sold_out ? 0 : 1, :sold_count => 0, :artwork => @artwork)
        end

    end

    def make_print(size_name, dimensions, material, artwork)
        price = DefaultPrice.where(:dimension => dimensions, :material => material).first
        
        if not price
            flash.now[:config_error] = "Default price has not been set for this material and dimension combination" 
            raise ActiveRecord::Rollback.new "Default price has not been set for this material and dimension combination"
        end

        print = Print.create :price => price.price, :size_name => size_name, :material => material, :dimensions => dimensions, :inventory_count => 0, :sold_count => 0, :artwork => @artwork
        @artwork.prints.append print

    end
end
