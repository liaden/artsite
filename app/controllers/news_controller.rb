require 'twitter'
require 'tumblr4r'

class NewsController < ApplicationController
    def index
        @tweets = Twitter.user_timeline("ArchaicSmiles").select do |tweet|
            not AutoTweets.where :tweet_id => tweet.id
        end
        @tumbles = Tumblr4r::Site.new("archaic-smiles.tumblr.com").find(:all, :limit => 50).select do |tumble|
            not AutoTumbles.where :tumble_id => tumble.post_id
        end
    end

    def caller
        "News"
    end
end
