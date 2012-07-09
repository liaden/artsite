class AddEmailToCommission < ActiveRecord::Migration
  def change
    add_column :commissions, :email, :string
  end
end
