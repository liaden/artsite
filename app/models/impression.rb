class Impression < ActiveRecord::Base

  scope :guest_impressions, lambda { where(:user_id => nil) }
  scope :user_impressions, lambda { where('user_id IS NOT NULL') }
  scope :artwork_impressions, lambda { where(:impressionable_type => :Artwork) }

  belongs_to :user

  geocoded_by :ip_address, :latitude => :latitude, :longitude => :longitude

  validates :ip_address, :presence => true
  #after_validation :geocode 

  validates_each :user_id do |record, attr, value|
    if record.user.try(:admin?)
      record.errors.add(attr, "Not tracking browsing behavior of admins")
    end
  end
end
