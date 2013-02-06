class ScheduleController < ApplicationController
    def index
        @shows = Show.order("date asc").where "date > ?", Time.now - 1.day
        @shows ||= []
    end

    def caller
        "Schedule"
    end
end
