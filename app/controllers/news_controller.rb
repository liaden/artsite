require 'twitter'
require 'tumblr4r'

class NewsController < ApplicationController
    
    caches_action :index, :expires_in => 1.hours

    def index
        @tweets = Twitter.user_timeline("ArchaicSmiles")
        @tumbles = Tumblr4r::Site.new("archaic-smiles.tumblr.com").find(:all, :limit => 50)
        render :index
    end

    def caller
        "News"
    end
end
