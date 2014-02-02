class MainController < ApplicationController
    helper :all

    MOST_RECENT_LIMIT = 1

    def index
        puts Artwork.all.inspect
        @artworks = Artwork.find(:all, :order => "created_at DESC").first MOST_RECENT_LIMIT
        @artwork = @artworks.first
        @artist_statement = Article.find_by_title :artist_statement
    end

    def subnavbar
      if admin?
         return render :admin_sub_navbar, :layout => false
      end

      render :subnavbar, :layout => false
    end
end
