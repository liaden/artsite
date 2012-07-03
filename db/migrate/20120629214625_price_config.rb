class PriceConfig < ActiveRecord::Migration
    def change
        create_table :default_prices do |t|
            t.string :dimension
            t.string :material
            t.decimal :price
        end
    end
end
