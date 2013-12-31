class ScheduleController < ApplicationController
    def index
        @shows = Show.upcoming || []
    end

    def caller
        "Schedule"
    end
end
