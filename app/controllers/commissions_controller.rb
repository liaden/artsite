class CommissionsController < ApplicationController
    def new
        @commission = Commission.new
    end

    def create
        @commission = Commission.new params[:commission]
        if @commission.save
            OrderMailer.commission_order(@commission).deliver
            flash[:notice] = "Idea has been sent. Thank you!"
        else
            flash[:error] = @commission.errors.messages
        end

        redirect_to home_path
    end

    def caller
        "Comission"
    end
end
