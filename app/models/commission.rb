class Commission < ActiveRecord::Base
    validates :email, :customer, :comments, :presence => true
end
