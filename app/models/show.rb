class Show < ActiveRecord::Base

    def self.valid_show_types
        [ "Gallery", "Convention" ]
    end

    scope :upcoming, where('date > ?', Date.yesterday)

    validates :name, :date, :address, :presence => true
    validates :show_type, :inclusion => { :in => valid_show_types }
end
