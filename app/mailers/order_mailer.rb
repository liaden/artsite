class OrderMailer < ActionMailer::Base
    default from: "archaicsmiles@gmail.com"
    
    def order_receipt(order)
        
        # don't send email if we are selling lessons
        return if order.prints.size == 0

        @order = order
        if order.user
            email = order.user.email
        else
            email = order.guest_email
        end
        mail :to => email, :subject => "Purchase receipt from ArchaicSmiles Shop."
    end

    def order_notification(order)

        return if order.prints.size == 0

        @order = order

        mail :to => "archaicsmiles@gmail.com", :subject => "Purchase #{@order.id} has been placed."
    end
end
