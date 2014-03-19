class ScheduleController < ApplicationController
    def index
        @shows = Show.upcoming.order('date ASC').decorate || []
    end

    def caller
        "Schedule"
    end
end
