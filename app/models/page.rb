class Page < ActiveRecord::Base
  def self.valid_types
    %w(tutorial video)
  end

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :page_type, :presence => true, :inclusion => { :in => Page.valid_types }
  
  def video?
    page_type == 'video'
  end
  
  def tutorial?
    page_type == 'tutorial'
  end

  validates_each :content do |record, attr, value|
    if record.video?
      record.errors.add(attr, 'Video pages must link to youtube.') unless value.match(/youtube.com/)
    end
  end
end
