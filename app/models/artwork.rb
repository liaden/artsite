class Artwork < ActiveRecord::Base
    validates :title, :description, :image_file_name, :presence => true

    has_attached_file :image, :styles => { :carousel => "400x200", :thumbnail => "80x80" }
    has_many :artwork_tags
	has_many :tags, :through => :artwork_tags, :uniq => true

    has_many :artwork_medium
    has_many :medium, :through => :artwork_medium

    has_many :prints

    accepts_nested_attributes_for :prints

    def sizes
        s = {}
        prints.each {|print| s[print.dimensions] = true if print.material != "original"}
        logger.debug "sizes = #{s.keys.sort}"

        s.keys.sort_by do |a| 
            width, height = a.split "x" 
            [ Integer(width), Integer(height) ]
        end
    end

    def price_of(material, size)
        logger.debug "material = #{material}; size = #{size}"
        print = prints.select {|print| print.material == material.to_s and print.dimensions == size.to_s }.first
        print.price
    end

    def canvases
        prints.select { |print| print.material == "canvas" }
    end

    def photopapers
        prints.select { |print| print.material == "photopaper" }
    end

    def original
        prints.find { |print| print.material == "original" } 
    end
end
