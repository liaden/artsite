class CreateAutoTweets < ActiveRecord::Migration
  def change
    create_table :auto_tweets do |t|
      t.integer :tweet_id

      t.timestamps
    end
  end
end
