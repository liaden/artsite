class CreateArtworkMedia < ActiveRecord::Migration
  def change
    create_table :artwork_media do |t|
        t.column :media_id, :integer
	    t.column :artwork_id, :integer
    end
  end
end
