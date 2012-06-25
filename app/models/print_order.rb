class PrintOrder < ActiveRecord::Base
    belongs_to :print
    belongs_to :order

    def framed?
        frame_size != nil and frame_size.size > 0
    end

    def self.frame_price(dimensions)
        height, width = Print.height_and_width dimensions

        PrintOrder.frame_price_helper height, width
    end

    def frame_price
        return 0 if print.original?

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
