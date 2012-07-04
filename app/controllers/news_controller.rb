require 'twitter'
require 'tumblr4r'

class NewsController < ApplicationController
    def index
        @tweets = Twitter.user_timeline("ArchaicSmiles")
        @tumbles = Tumblr4r::Site.new("archaic-smiles.tumblr.com").find(:all, :limit => 50)
    end

    def caller
        "News"
    end
end
