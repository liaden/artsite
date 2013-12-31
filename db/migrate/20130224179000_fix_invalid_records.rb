class FixInvalidRecords < ActiveRecord::Migration
  def change
    Print.all(:include => :artwork).each do |p|
        if p.artwork.nil?
            p.destroy
        end
    end

    Tag.merge_duplicate_names!
  end
end
