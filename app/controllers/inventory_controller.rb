class InventoryController < ApplicationController
    def index
        return redirect_to home_path unless admin?

        @artworks = Artwork.all
    end

    def edit
        return redirect_to home_path unless admin?

        @artwork = Artwork.find(params[:id])
    end

    def update
        return redirect_to home_path unless admin?

        @artwork = Artwork.includes(:prints).find(params[:id])

        params.keys.grep(/canvas/).each do |key|
            update_by_key key
        end

        params.keys.grep(/photopaper/).each do |key|
            update_by_key key
        end

        #if true
            flash[:notice] = "Inventory updated!"
        #end

        redirect_to inventory_path(@artwork)
    end

private
    def update_by_key(key)
        material, size, ignored = key.split('_')

        # "N/A" for material and size combination that does not exist
        count = Integer(params[key]) rescue return

        if count >= 0
            print = @artwork.prints.where(:material => material, :size_name => size).first

            return flash[:error] = "No print found for #{material} and #{size}" unless print


            print.inventory_count = count
            print.save
        else
            msg ="#{key.gsub('_', ' ')} must have at least 0 items."

            flash[:error] = msg
        end
    end
end
