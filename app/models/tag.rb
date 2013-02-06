class Tag < ActiveRecord::Base
    has_many :artwork_tags
    has_many :artworks, :through =>  :artwork_tags, :uniq => true

    validates :name, :presence => true
    validates_uniqueness_of :name
    
    before_validation :cleanup_data

    def cleanup_data
        self.name.strip! if self.name

        true
    end

end
