class CreateArtworkTags < ActiveRecord::Migration
  def change
    create_table :artwork_tags do |t|
        t.column :artwork_id, :integer
	    t.column :tag_id, :integer
    end
  end
end
