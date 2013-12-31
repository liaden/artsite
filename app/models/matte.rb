class Matte < ActiveRecord::Base
    belongs_to :matte_color

    validates :size, :presence => true
    validates :size, :numericality => { :greater_than => 0 }, :if => :matted?

    def matted? 
        not matte_color.nil?
    end

    def height_width inner_height_width
        return inner_height_width unless matted?
        { :height => inner_height_width[:height] + size * 2, :width => inner_height_width[:width] + size * 2 }
    end

    def price inner
        return 0.0 unless matted?

        outer = height_width(inner)
        material_used = outer[:height]*outer[:width] - inner[:height]*inner[:width]

        (material_used * 0.3).round
    end

    def self.unmatted
        @matte ||= Matte.find_by_size(0)
    end

    def self.create_unmatted
        Matte.create :size => 0, :matte_color => nil 
    end

end

if Matte.find_by_size(0) == nil
    Matte.create(:size => 0, :matte_color => nil)
end
