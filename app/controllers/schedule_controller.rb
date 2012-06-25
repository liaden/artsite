class ScheduleController < ApplicationController
    def index
        @shows = Show.where "date > ?", Time.now
    end

    def caller
        "Schedule"
    end
end
