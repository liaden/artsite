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

    validates_numericality_of :inventory_count, :greater_than => 0
    validates_numericality_of :sold_count, :greater_than => 0

    validate do |print|
        if not print.dimensions
            errors.add :dimensions, "Please specify the dimensions for the print."
        else
            width, height = print.dimensions.split 'x'
            
            Integer(width) and Integer(height) rescue errors.add :dimensions, "Format for dimensions must be [width]x[height]."
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

    def height_and_width
        Print.height_and_width dimensions
    end

    def self.height_and_width(dimension)
        match = dimension.match /(\d+)x(\d+)/
        [ match[1], match[2] ]
    end

    def self.ratio_to_small(ratio)
        ratio == "16x20" ? "5x7" : "4x6"
    end

    def self.ratio_to_medium(ratio)
        ratio == "16x20" ? "8x10" : "8x12"
    end

    def self.ratio_to_large(ratio)
        ratio == "16x20" ? "11x14": "12x18"
    end

    def self.ratio_to_xlarge(ratio)
        ratio == "16x20" ? "16x20" : "20x30"
    end
end
