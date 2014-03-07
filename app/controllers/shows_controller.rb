class ShowsController < ApplicationController
    decorates_assigned :art_show

    def new
        return redirect_to :action => :index unless admin?

        @art_show = Show.new
    end

    def create
        return redirect_to :action => :index unless admin?

        @art_show = Show.new(params[:show]) 
        if @art_show.save
            flash[:notice] = "Successfully created a new show."
        end

        redirect_to :action => :new
    end

    def show
        @art_show = Show.find_by_id params[:id]
    end

    def edit
        return redirect_to :action => :index unless admin?

        @art_show = Show.find_by_id params[:id]
    end

    def update
        return redirect_to :action => :index unless admin?

        @art_show = Show.find_by_id params[:id]

        @art_show.update_attributes params[:show]

        render :show
    end
end
