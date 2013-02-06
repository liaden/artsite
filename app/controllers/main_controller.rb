class MainController < ApplicationController
    helper :all

    MOST_RECENT_LIMIT = 5

    def index
        @artworks = Artwork.find(:all, :order => "created_at DESC").first MOST_RECENT_LIMIT
    end

end
