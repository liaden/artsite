class Show < ActiveRecord::Base

  def self.valid_show_types
    [ "Gallery", "Convention" ]
  end

  scope :upcoming, -> { where("date > ?", Date.yesterday).order("date ASC") }

  def self.next
    upcoming.limit(1).first
  end

  validates :name, :date, :address, :description, :presence => true
  validates :show_type, :inclusion => { :in => valid_show_types }
end
