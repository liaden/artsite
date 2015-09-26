class Artwork < ActiveRecord::Base
   extend Taggable

   taggable Medium, :plural => :medium # JOEL TODO: fix the plural
   taggable Tag

   validates :title, :description, :image_file_name, :presence => true
   validates :fanart, :featured, :inclusion => { :in => [true, false] }

   has_attached_file :image, {
                       :styles => { :thumbnail => "100x100#", :medium => '250x250#' },
                     }.merge(PAPERCLIP_STORAGE_OPTIONS)


   # prints / purchasing relation
   has_many :prints, :autosave => true do
     def canvas() where(:material => 'canvas') end
     def photopapers() where(:material => 'photopaper') end
     def original() where(:material => 'original') end
   end

   scope :for_year, lambda { |year| where("created_at >= ? and created_at < ?", "#{year}-01-01", "#{(year.to_i + 1)}-01-01") }
   scope :featured, -> { where(featured: true) }
   scope :fanart, -> { where(fanart: true) }
   scope :original, -> { where(fanart: false) }

   def self.newest
     Artwork.limit(1).order('created_at DESC').first
   end

   accepts_nested_attributes_for :prints

   validate :created_at do
     return true if @created.nil?

     # created = 'some date' has been called
     begin
         Date.strptime(@created, '%m/%d/%Y')
     rescue
         return self.errors.add(:created_at, "Date '#{@created}' is not in the valid format 'mm/dd/yyyy'")
     end

     if created_at.year < 1000
         return self.errors.add(:created_at, "Date should have years formated as yyyy")
     end
   end

   # pretty url stuff
   extend FriendlyId
   friendly_id :title, :use => [:slugged, :finders, :history]

   def sizes
     s = {}
     prints.each {|print| s[print.dimensions] = true if print.material != "original"}
     logger.debug "sizes = #{s.keys.sort}"

     s.keys.sort_by do |a|
       width, height = a.split "x"
       [ Integer(width), Integer(height) ]
     end
   end

   def created=(string_date)
     # force invoking the function with nil to store an empty string
     @created = string_date.to_s
     return unless string_date

     begin
       self.created_at = Date.strptime(string_date, '%m/%d/%Y')
     rescue ArgumentError
       # could not parse in given format
       # handle in validation of @created
     end
   end

   def price_of(material, size)
     warn "price_of is deprecated. use find_print.price. called from #{caller.first}"
     logger.debug "material = #{material}; size = #{size}"
     print = prints.select {|print| print.material == material.to_s and print.dimensions == size.to_s }.first
     print.price if print

     Artwork.price_of material, size
   end

   def find_print(params)
     prints.where(params).first
   end

   def self.price_of(material, size)
     price_point = DefaultPrices.all.select {|price_point| price_point.material == material.to_s and price_point.dimension == size.to_s }.first
     price_point.price
   end

   def has_size?( size_name )
     prints.where(:size_name => size_name).size > 0 if id
   end

   def original
     prints.original.first
   end

   def original?
     not fanart?
   end

   delegate :dimensions, :to => :original, :prefix => true
end
