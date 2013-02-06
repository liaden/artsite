class ArtworkMedium < ActiveRecord::Base
    #validates_presence_of :artwork, :medium
    belongs_to :artwork
    belongs_to :medium
end
