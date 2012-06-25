class ArtworkMedium < ActiveRecord::Base
    belongs_to :artwork
    belongs_to :medium
end
