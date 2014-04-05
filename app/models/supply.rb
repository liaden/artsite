require 'open-uri'

class Supply < ActiveRecord::Base

  def self.supply_categories
    %w(brushes media papers)
  end

  validates_presence_of :name, :category, :referral_url, :description, :short_description
  validates :category, :inclusion => { :in => supply_categories }

  def verify_url
    HTTPClient.new.get(referral_url).status  == 200
  rescue => e
    false
  end
end
