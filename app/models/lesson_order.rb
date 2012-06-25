class LessonOrder < ActiveRecord::Base
    belongs_to :lesson
    belongs_to :order
end
