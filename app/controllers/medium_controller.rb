class MediumController < ApplicationController
    def show
        @media = Medium.where(:id => params[:id]).first
        @artworks = @media.artworks
        render 'artworks/index'
    end
end
