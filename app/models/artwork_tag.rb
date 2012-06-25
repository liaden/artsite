class ArtworkTag < ActiveRecord::Base
    belongs_to :artwork
    belongs_to :tag
end
