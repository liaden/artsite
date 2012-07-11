class MainController < ApplicationController
    helper :all
    def index
        @artworks = Artwork.find(:all, :order => "created_at DESC")
    end

end
