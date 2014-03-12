class TwitterService
  include Twitter::REST::Utils

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
    end
  end

  def timeline_options(since = nil)
    options = { :include_rts => false, :exclude_replies => true, :count => 200 }
    options[:since_id] = since unless since
  end

  def oembed_options
    {}
  end

  def client
    @client
  end

  def sync
    latest = Tweet.last

    new_tweets = client.user_timeline('370187188', timeline_options(latest.try(:twitter_id)))
    client.oembeds(new_tweets, oembed_options).each do |oembed_tweet|
      Tweet.create! :html => oembed_tweet.html, :twitter_id => oembed_tweet.url.to_s.split('/').last
    end
  end
end
