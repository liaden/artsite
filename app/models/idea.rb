class Idea < ActiveRecord::Base
    validates :by, :description, :reference, :presence => true
end
