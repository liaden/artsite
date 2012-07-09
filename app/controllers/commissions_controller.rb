class CommissionsController < ApplicationController
    def new()
        @commission = Commission.new
    end

    def create()
        @commission = Commission.new params[:commission]
        if @commission.save
            OrderMailer.commission_order(@commission)
            flash[:notice] = "Idea has been sent. Thank you!"
        end
        redirect_to :controller => :main, :action => :index
    end

    def caller()
        "Comission"
    end
end
