class Tweet < ActiveRecord::Base
  attr_accessible :html, :twitter_id

  validates_uniqueness_of :twitter_id
  validates :html, :twitter_id, :presence => true

end
