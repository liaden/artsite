class PrintOrder < ActiveRecord::Base
    belongs_to :print
    belongs_to :order

    def framed?
        PrintOrder.framed? frame_size
    end

    def self.framed?(frame_size)
        not_framed = frame_size == "no_frame" || frame_size.nil?
        !not_framed
    end

    def price
        print.price + frame_price
    end

    def self.frame_price(dimensions, frame_size)
        return 0 unless framed? frame_size

        dimensions = Print.height_width dimensions

        PrintOrder.frame_price_helper dimensions[:height], dimensions[:width]
    end

    def frame_price
        return 0 if print.original? or not framed?

        dimensions = Print.height_width print.dimensions

        PrintOrder.frame_price_helper dimensions[:height], dimensions[:width]
    end

    private

    def self.frame_price_helper(height, width)
        perimeter = (Integer(height)+Integer(width))*2
        
        # costs $0.2/inch
        cost = perimeter * 0.2

        # make sure profit is at least 50% (covers extra shipping cost and assembly time)
        cost *= 2

        # round up to nearest 5
        temp = Integer(cost/5)
        price = temp * 5 < cost ? (temp+1)*5 : temp * 5

        return price
    end
end
