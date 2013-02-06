class Address < ActiveRecord::Base
    validates :recipient, :line1, :city, :state, :zipcode, :presence => true
end
