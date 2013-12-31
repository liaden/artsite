class Cart
    def self.of user
        @user = user
        @order = user.active_order
    end

    def remove purchasable
        item_name = item.class.name
    end

    def add purchasable
    end
end
