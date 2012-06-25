class PrintPrice < ActiveRecord::Base
    def price_to_s
        if is_sold == :SOLD
            "SOLD"
        else
            "#{price-1}.95"
        end
    end
end
