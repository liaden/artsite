class Show < ActiveRecord::Base

    def self.valid_show_types
        [ "Gallery", "Convention" ]
    end

    validates :name, :date, :address, :presence => true
    validates :show_type, :inclusion => { :in => valid_show_types }
end
