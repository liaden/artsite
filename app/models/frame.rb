class Frame < ActiveRecord::Base
    validates :price_per_inch, :depth, :thickness, :linear_inches, :presence => true

    validates :price_per_inch, :depth, :thickness, :linear_inches, :numericality => { :greater_than_or_equal_to => 0 }

    def self.no_frame
        @unframed_instance ||= Frame.find_by_thickness(0.0 )
    end

    def self.unframed
        no_frame
    end

    def self.create_unframed
        Frame.create :price_per_inch => 0, :depth => 0, :thickness => 0, :linear_inches => 0
    end

    def perimeter dimensions
        #   new height                          new width
        2*(dimensions[:height].to_i + 2*thickness + dimensions[:width].to_i + 2 *thickness)
    end

    def height_width dimensions
        { :height => 2*thickness+dimensions[:height], :width => 2*thickness+dimensions[:width] }
    end

    def price print
        return 0 if print.original?

        cost = perimeter(print.height_width) * price_per_inch  
        rough = cost * 3
        (rough/5).round*5
    end

    def cost print
    end

    def framed?
       Frame.unframed.id != id
    end

end
