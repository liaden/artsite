class PagesController < ApplicationController
  before_filter :require_admin_or_send_home
  before_filter :get_article

  def edit
  end

  def update
    if @article.update_attributes params[:article]
        redirect_to home_path
    else
        render :action => 'edit'
    end
  end

private
  def get_article
    @article = Article.find_by_id(params[:id])
  end
end
