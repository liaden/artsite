class ScheduleController < ApplicationController
    def index
        @shows = Show.upcoming.decorate || []
    end

    def caller
        "Schedule"
    end
end
