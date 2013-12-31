class RecommendedMatteColor < ActiveRecord::Base
    belongs_to :artwork
    belongs_to :matte_color

    validates :artwork_id, :matte_color_id, :presence => true
end

