class Medium < ActiveRecord::Base
    has_many :artwork_medium
    has_many :artworks, :through => :artwork_medium

    validates :name, :presence => true
end
