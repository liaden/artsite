class DefaultPrice < ActiveRecord::Base
    def self.valid_materials
        Print.materials
    end

    validates :material, :price, :dimension, :presence => true
    validates :material, :inclusion => { :in => valid_materials }

    validates_each :price do |record, attr, value|
        if value == nil 
            record.errors.add(attr, 'price cannot be nil')
        else
            record.errors.add(attr, 'invalid price') if value <= 0
        end
    end

    def self.add_test_defaults_to_database # for testing
        Print.materials_sans_original.each do  |material|
            ["5x7", "8x10", "11x14", "16x20", "8x12", "12x18", "20x30"].each do |dimension|
                DefaultPrice.create :dimension => dimension, :material => material, :price => 5.00
            end
        end
    end
end

