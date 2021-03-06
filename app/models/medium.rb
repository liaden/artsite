class Medium < ActiveRecord::Base
  has_many :artwork_medium
  has_many :artworks, through: :artwork_medium

  validates :name, :presence => true
  validates_uniqueness_of :name

  before_validation :cleanup_data

  def cleanup_data
    self.name.strip! if self.name

    true
  end
end
