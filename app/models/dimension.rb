class Dimension < ActiveRecord::Base
    validates :width, :height, :presence => true

    validates_each :width, :height do |record, attr, value|
        record.errors.add(attr, 'must be 1 or larger') unless value and value >= 1
    end

    def to_s
        "#{width}x#{height}"
    end

    def parse_dimensions(str)
        Dimension.parse_dimensions(str)
    end

    def self.parse_dimensions(str)
        h,x,w = str.partition('x')
        { :height => Integer(h), :width => Integer(w) }
    end

    def self.valid_dimension?(str)
        str =~ /\d+x\d+/        
    end

    def self.create_from_str(str)
        Dimension.new self.parse_dimensions(str)
    end

end
