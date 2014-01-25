class MainController < ApplicationController
    helper :all

    MOST_RECENT_LIMIT = 5

    def index
        @artworks = Artwork.find(:all, :order => "created_at DESC").first MOST_RECENT_LIMIT
        @artist_statement = Article.find_by_title :artist_statement
    end

    def subnavbar
      if admin?
         return render :admin_sub_navbar, :layout => false
      end

      render :subnavbar, :layout => false
    end
end
