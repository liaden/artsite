class TagsController < ApplicationController

    before_filter :require_admin_or_send_home, :except => :show
    before_filter :set_tag_and_artworks, :except => [:clear_orphans, :index]

    def index
        @tags = Tag.all
    end

    def show
        render 'artworks/index'
    end

    def clear_orphans
        @orphaned = Tag.all(:include => :artworks).select { |t| t.artworks.empty? }

        @cleaned_up = @orphaned.size
        @orphaned.each { |t| t.destroy }

        flash[:notice] = "Removed #{@cleaned_up} orphaned tags"
        redirect_to :action => :index
    end

    def edit
    end

    def update
        Tag.transaction do
            @other_tag = Tag.find_by_name params[:tag][:name]
            if @other_tag
                @other_tag.artworks << @artworks
                @other_tag.save!
                @tag.destroy
            else
                @tag.update_attributes! params[:tag]
            end
        end
        redirect_to :action => :index
    end

    def destroy
        @tag.destroy
        redirect_to :action => :index
    end

private

    def set_tag_and_artworks
        @tag = Tag.find_by_id params[:id]
        @artworks = @tag.artworks
    end

end
