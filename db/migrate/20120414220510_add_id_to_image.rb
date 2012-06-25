class AddIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :artwork_id, :integer

  end
end
