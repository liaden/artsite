class TagsController < ApplicationController
    def show
        @tag = Tag.where(:id => params[:id]).first
        @artworks = @tag.artworks
        render 'artworks/index'
    end
end
