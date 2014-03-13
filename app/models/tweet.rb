class Tweet < ActiveRecord::Base
  attr_accessible :html, :twitter_id

  validates_uniqueness_of :twitter_id
  validates :html, :twitter_id, :presence => true

  scope :last_seven_days, where('created_at > ?', 7.days.ago)
end
