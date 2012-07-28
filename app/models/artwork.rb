class Artwork < ActiveRecord::Base
    validates :title, :description, :image_file_name, :presence => true

    has_attached_file :image, 
                      :styles => { :carousel => "500x500", :thumbnail => "100x100" },
                      :storage => :s3,
                      :bucket => ENV['S3_BUCKET_NAME'],
                      :s3_credentials => {
                          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                      }


    has_many :artwork_tags
	has_many :tags, :through => :artwork_tags, :uniq => true

    has_many :artwork_medium
    has_many :medium, :through => :artwork_medium

    has_many :prints

    accepts_nested_attributes_for :prints

    extend FriendlyId
    friendly_id :title, :use => :slugged

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
        print.price if print

        Artwork.price_of material, size
    end

    def self.price_of(material, size)

        price_point = DefaultPrices.all.select {|price_point| price_point.material == material.to_s and price_point.dimension == size.to_s }.first
        price_point.price
    end

    def canvases
        prints.where(:material => "canvas" ).sort if id
    end

    def photopapers
        prints.where(:material => "photopaper").sort if id
    end

    def original
        prints.where(:material => "original").first if id
    end

    def has_size?( size_name )
        prints.where(:size_name => size_name).size > 0 if id
    end
end
