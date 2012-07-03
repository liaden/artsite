class Order < ActiveRecord::Base
    SHIPPING_COST = 5

    belongs_to :user
    belongs_to :address

    has_many :print_orders
    has_many :prints, :through => :print_orders

    has_many  :lesson_orders
    has_many :lessons, :through => :lesson_orders

    validates :state, :inclusion => { :in => ["open", "closed"], :message => "%{value} is not a valid order state." }

    attr_accessor :stripe_card_token

    def total
        prices = (print_orders + lessons).map { |item| item.price }
        prices.size > 0 ? prices.reduce(:+) : 0
    end

    def shipping_cost
        return 0 if total >= 50 or prints.size == 0
        return SHIPPING_COST
    end

    def empty_cart?
        prints.size == 0 and lessons.size == 0
    end

    def empty?
        lessons.size == 0 and prints.size == 0
    end
end
