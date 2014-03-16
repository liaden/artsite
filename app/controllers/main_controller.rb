class MainController < ApplicationController
    helper :all
    
    decorates_assigned :artwork
    decorates_assigned :next_show

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
