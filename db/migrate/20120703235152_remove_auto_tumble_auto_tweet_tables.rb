class RemoveAutoTumbleAutoTweetTables < ActiveRecord::Migration
  def up
    drop_table :auto_tumbles
    drop_table :auto_tweets
  end

  def down
  end
end
