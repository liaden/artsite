class AddMatteIdToPrintOrder < ActiveRecord::Migration
  def change
    add_column :print_orders, :matte_id, :integer

  end
end
