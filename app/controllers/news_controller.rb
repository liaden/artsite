require 'tumblr4r'

class NewsController < ApplicationController
    
    caches_action :index, :expires_in => 1.hours

    def index

      TwitterService.new.sync
      @tweets = Tweet.last_seven_days

      @tumbles = Tumblr4r::Site.new("archaic-smiles.tumblr.com").find(:all, :limit => 50)
      render :index
    end

    def caller
        "News"
    end
end
