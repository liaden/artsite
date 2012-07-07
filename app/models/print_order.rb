class PrintOrder < ActiveRecord::Base
    belongs_to :print
    belongs_to :order

    def framed?
        frame_size != "no_frame"
    end

    def price
        logger.debug "**** #{print.price} ; #{frame_price}"
        print.price + frame_price
    end

    def self.frame_price(dimensions, frame_size)
        return 0 if frame_size == "no_frame"

        height, width = Print.height_and_width dimensions

        PrintOrder.frame_price_helper height, width
    end

    def frame_price
        return 0 if print.original? or frame_size == :no_frame

        height, width = Print.height_and_width print.dimensions

        PrintOrder.frame_price_helper height, width
    end

    private

    def self.frame_price_helper(height, width)
        perimeter = (Integer(height)+Integer(width))*2
        logger.debug "perimeter = #{perimeter}"
        
        # costs $0.2/inch
        cost = perimeter * 0.2
        logger.debug "cost = #{cost}"

        # make sure profit is at least 50% (covers extra shipping cost and assembly time)
        cost *= 2

        # round up to nearest 5
        temp = Integer(cost/5)
        logger.debug "temp = #{temp}"
        price = temp * 5 < cost ? (temp+1)*5 : temp * 5

        return price
    end
end
