class Print < ActiveRecord::Base
    belongs_to :artwork
    has_many :print_orders
    has_many :orders, :through => :print_orders

    def self.sizes
        ["small", "medium", "large", "extra_large", "original"]
    end

    def self.materials 
        ["photopaper", "canvas", "original"]
    end

    def self.sizes_sans_original
        sizes - ["original"]
    end

    def self.materials_sans_original
        materials - ["original"]
    end

    validates :size_name, :inclusion => { :in => Print.sizes, :message => "%{value} is not a valid name" }
    validates :material, :inclusion => { :in => Print.materials, :message => "%{value} is not a valid material" }
    validates :artwork_id, :dimensions, :price, :presence => true

    validates_numericality_of :inventory_count, :greater_than => -1
    validates_numericality_of :sold_count, :greater_than => -1

    validate do |print|
        width, height = print.dimensions.split 'x'
        
        Integer(width) and Integer(height) rescue errors.add :dimensions, "Format for dimensions must be [width]x[height]."

        if print.price
            errors.add :price, "A #{print.size_name} print should be free" unless print.price > 0.00
        else
            errors.add :price, "No price specified for the #{print.size_name} print of #{print.artwork.title}"
        end
    end

    def print_type
        if material == "photopaper"
            "Art Print"
        elsif material == "canvas"
            "Canvas Print"
        else
            "Original Artwork"
        end
    end

    def original?
        material == "original"
    end

    def is_not_soldout?
        not is_sold_out
    end

    def is_not_on_show?
        not is_on_show
    end

    #def height_and_width
    #    Print.height_and_width dimensions
    #end

    #def self.height_and_width(dimension)
    #    warn "height_and_width is deprecated. use height_width. called from #{caller.first}"
    #    match = dimension.match /(\d+)x(\d+)/
    #    [ match[1], match[2] ]
    #end

    def self.height_width(dimensions)
        parts = dimensions.split('x')
        return :height => parts[0], :width => parts[1]
    end

    def self.ratio_to_small(ratio)
        ratio > 0.7 ? "5x7" : "4x6"
    end

    def self.ratio_to_medium(ratio)
        self.pick_best_aspect_ratio(ratio) ? "8x10" : "8x12"
    end

    def self.ratio_to_large(ratio)
        self.pick_best_aspect_ratio(ratio) ? "11x14": "12x18"
    end

    def self.ratio_to_xlarge(ratio)
        self.pick_best_aspect_ratio(ratio) ? "16x20" : "20x30"
    end

    private 
    def self.pick_best_aspect_ratio(original_ratio)
        original_ratio > 0.733333 # true when closer to 3:4 ratio, false when closer to 2:3
    end

end
