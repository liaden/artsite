class Tag < ActiveRecord::Base
  has_many :artwork_tags
  has_many :artworks, :through =>  :artwork_tags, :uniq => true

  validates :name, :presence => true
  validates_uniqueness_of :name
  
  before_validation :cleanup_data

  def cleanup_data
    self.name.strip! if self.name

    true
  end

  def self.merge_duplicate_names!
    Tag.transaction do
      tags_with_whitespace = Tag.where("name LIKE ' % or name LIKE '% '")

      tags_with_whitespace.each do |t|
        t.cleanup_data

        # try to save without whitespace
        # if we can't, it's cause we are not unique
        unless t.save
          other = Tag.find_by name: t.name

          # save with exception to cancel transaction
          # since the error is not caused from duplicates
          t.save! if other.nil?

          other.artworks << t.artworks
          other.save!

          t.destroy
        end
      end
    end
  end

end
