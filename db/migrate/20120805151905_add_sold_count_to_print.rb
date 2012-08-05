class AddSoldCountToPrint < ActiveRecord::Migration
  def change
    add_column :prints, :sold_count, :integer

  end
end
