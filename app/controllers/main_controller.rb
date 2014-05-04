class MainController < ApplicationController
    helper :all
    
    decorates_assigned :artwork
    decorates_assigned :next_show

    def index
      @artwork = Artwork.newest
      @next_show = Show.next
    end

    def admin_controls
      if admin?
         return render :admin_controls, :layout => false
      end

      render :inline => '', :layout => false
    end

    def preview_markdown
      @markdown = params[:markdown]

      render :preview_markdown, :layout => false
    end
end
