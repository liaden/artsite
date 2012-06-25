class AddGuestEmailToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :guest_email, :string

  end
end
