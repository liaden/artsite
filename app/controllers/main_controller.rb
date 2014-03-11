class MainController < ApplicationController
    helper :all

    def index
      @artwork = Artwork.newest
      @next_show = Show.next
    end

    def subnavbar
      if admin?
         return render :admin_sub_navbar, :layout => false
      end

      render :subnavbar, :layout => false
    end
end
