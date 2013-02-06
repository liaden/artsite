class ShowsController < ApplicationController
    def new
        return redirect_to :action => :index unless admin?

        @show = Show.new
    end

    def create
        return redirect_to :action => :index unless admin?

        @show = Show.new(params[:show]) 
        if @show.save
            flash[:notice] = "Successfully created a new show."
        end

        redirect_to :action => :new
    end

    def show
        @show = Show.find_by_id params[:id]
    end

    def edit
        return redirect_to :action => :index unless admin?

        @show = Show.find_by_id params[:id]

    end

    def update
        return redirect_to :action => :index unless admin?

        @show = Show.find_by_id params[:id]

        puts params

        @show.update_attributes params[:show]

        render :show
    end
end
