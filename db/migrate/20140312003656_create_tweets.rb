class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitter_id
      t.string :html

      t.timestamps
    end
  end
end
