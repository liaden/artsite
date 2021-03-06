class OrderMailer < ActionMailer::Base
    default :from => "no-reply@archaicsmiles.com"
    
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

    def commission_order(commission)
        @commission = commission

        mail :to => "Holly Morningstar <archaicsmiles@gmail.com>", :subject => "Commission Idea from #{commission.customer}"

    end
end
