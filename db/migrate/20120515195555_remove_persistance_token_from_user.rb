class RemovePersistanceTokenFromUser < ActiveRecord::Migration
  def up
    remove_column :Users, :persistance_token
  end

  def down
  end
end
