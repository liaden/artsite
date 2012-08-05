class Idea < ActiveRecord::Base
    validates :by, :presence => true
    validates :description, :presence => true
    validates :reference, :presence => true
end
