class Tweet < ActiveRecord::Base
  validates_uniqueness_of :twitter_id
  validates :html, :twitter_id, :presence => true

  scope :last_seven_days, lambda { where('created_at > ?', 7.days.ago) }
end
