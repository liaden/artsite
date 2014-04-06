class Page < ActiveRecord::Base
  def self.valid_types
    %w(tutorial video)
  end

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :page_type, :presence => true, :inclusion => { :in => Page.valid_types }
end
