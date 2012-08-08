require 'twitter'
require 'tumblr4r'

class NewsController < ApplicationController
    
    caches_action :index, :expires_in => 1.hours

    def index
        begin 
            @tweets = Twitter.user_timeline("ArchaicSmiles") 
        rescue Twitter::Error::BadRequest => e
            @tweets = []
        end

        @tumbles = Tumblr4r::Site.new("archaic-smiles.tumblr.com").find(:all, :limit => 50)
        render :index
    rescue Twitter::Error::BadRequest => e
        @tweets = []
        
    end

    def caller
        "News"
    end
end
