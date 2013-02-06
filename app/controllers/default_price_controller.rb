class DefaultPriceController < ApplicationController
    def edit
        return redirect_to home_path unless admin?

        @photopapers = DefaultPrice.where(:material => "photopaper")
        @canvases = DefaultPrice.where(:material => "canvas")
    end

    def update
        return redirect_to home_path unless admin?
       
        ids = params.keys.grep /^\d+/

        logger.debug "ids = #{ids}"

        ids.each do |id|
            default = DefaultPrice.find_by_id id

            if default == nil
                flash[:error] = "Could not find instance of default price that matched id specified: #{id}."
                return redirect_to price_edit_path
            end

            new_price = BigDecimal(params[id])

            if params[:commit] == "Apply to all"
                if default.price != new_price
                    Print.where(:dimensions => default.dimension, :material => default.material).each do |print|
                        print.price = new_price
                        print.save
                    end
                end
            end

            default.price = new_price
            default.save
        end

        redirect_to price_edit_path
    end

end
