class ShowsController < ApplicationController
    def new
        redirect_to :action => :index unless admin?

        @show = Show.new
    end

    def create
        redirect_to :action => :index unless admin?

        @show = Show.new(params[:show]) 
        if @show.save
            flash[:notice] = "Successfully created a new show."
        end

        redirect_to :action => :new
    end

    def show
        @show = Show.where :id => params[:id]
    end

    def edit
        redirect_to :action => :index unless admin?

        @show = Show.where :id => params[:id]
    end

    def update
        redirect_to :action => :index unless admin?

        @show = Show.where :id => params[:id]
    end
end
