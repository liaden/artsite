class Tag < ActiveRecord::Base
    has_many :artwork_tags
    has_many :artworks, :through =>  :artwork_tags, :uniq => true

    validates :name, :presence => true

end
