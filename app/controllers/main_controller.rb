class MainController < ApplicationController
    helper :all
    def index
        @artworks = Artwork.all
    end

end
