class IdeasController < ApplicationController
    def index
        return redirect_to main_path unless admin?

        @ideas = Idea.all
    end

    def show
        return redirect_to main_path unless admin?

        @idea = Idea.find(params[:id])
    end

    def new
        return redirect_to main_path unless admin?

        @idea = Idea.new
    end

    def create
        return redirect_to main_path unless admin?

        @idea = Idea.new(params[:idea])

        @idea.reference = params[:reference]

        if @idea.save
        else
        end

        redirect_to new_idea_path
    end

    def destroy
        return redirect_to main_path unless admin?

        @idea = Idea.find(params[:id])

        @idea.delete

        redirect_to ideas_path
    end


end
