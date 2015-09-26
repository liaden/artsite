class Tweet < ActiveRecord::Base
  validates_uniqueness_of :twitter_id
  validates :html, :twitter_id, :presence => true

  scope :last_seven_days, -> { where("created_at > ?", 7.days.ago) }
end
