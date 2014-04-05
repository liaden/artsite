class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :category
      t.string :referral_url
      t.text :description
      t.text :short_description

      t.timestamps
    end
  end
end
