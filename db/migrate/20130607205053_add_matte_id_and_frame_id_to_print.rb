class AddMatteIdAndFrameIdToPrint < ActiveRecord::Migration
  def change
    add_column :prints, :frame_id, :integer

    add_column :prints, :matte_id, :integer

  end
end
