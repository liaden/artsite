class User < ActiveRecord::Base
    acts_as_authentic 

    has_many :orders
    belongs_to :address

    def active_order
        orders.where(:state => "open")[0]
    end

    def old_orders
        orders.where :state => "closed"
    end

    def create_active_order
        Order.create :user => self, :state => "open"
    end

    def admin?
        privilege == 1
    end
end
