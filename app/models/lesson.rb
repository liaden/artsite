class Lesson < ActiveRecord::Base
    validates :name, :description, :presence => true
    # JOEL TODO: validate date is greater than today and free_spots is greater than 0
    
    has_many :lesson_orders
    has_many :orders, :through => :lesson_orders

    scope :upcoming, where('date > ?', Date.yesterday)
end
