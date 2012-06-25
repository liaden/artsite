class Show < ActiveRecord::Base
    validates :name, :building, :address, :presence => true
    validates :show_type, :inclusion => { :in => [ "Gallery", "Convention" ] }
end
