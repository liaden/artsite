# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

ActiveRecord::Base.transaction do
    DefaultPrice.create :dimension => '4x6', :material => 'photopaper', :price => 5.00
    DefaultPrice.create :dimension => '5x7', :material => 'photopaper', :price => 5.00
    DefaultPrice.create :dimension => '8x10', :material => 'photopaper', :price => 10.00
    DefaultPrice.create :dimension => '8x12', :material => 'photopaper', :price => 10.00
    DefaultPrice.create :dimension => '11x14', :material => 'photopaper', :price => 20.00
    DefaultPrice.create :dimension => '12x18', :material => 'photopaper', :price => 25.00
    DefaultPrice.create :dimension => '16x20', :material => 'photopaper', :price => 30.00
    DefaultPrice.create :dimension => '20x30', :material => 'photopaper', :price => 40.00

    DefaultPrice.create :dimension => '8x10', :material => 'canvas', :price => 30.00
    DefaultPrice.create :dimension => '8x12', :material => 'canvas', :price => 30.00
    DefaultPrice.create :dimension => '11x14', :material => 'canvas', :price => 60.00
    DefaultPrice.create :dimension => '12x18', :material => 'canvas', :price => 60.00
    DefaultPrice.create :dimension => '16x20', :material => 'canvas', :price => 100.00
    DefaultPrice.create :dimension => '20x30', :material => 'canvas', :price => 125.00

    if Rails.env.development? or Rails.env.test?

        User.create :username => 'holly', :email => 'holly@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd', :privilege => 1
        User.create :username => 'logainsrequiem', :email => 'logainsrequiem@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd'

        tags = [ Tag.new(:name => "Feminism"), Tag.new(:name => "Butterflies")]

        tags.each { |tag| tag.save }

        medium = [ Medium.new(:name => "Colored Pencil"), Medium.new(:name => "Ink"), Medium.new( :name => "Water Color") ]
        medium.each { |media| media.save }

        art1 = Artwork.create! :title => 'Butterfly', :description => "The wings of the butterfly caused a typhoon halfway across the world", :image => File.open('db/seed_images/butterfly.jpg'), :tags => [ tags[0], tags[1] ], :medium => [ medium[0], medium[1] ]
        art1.save!

        art2 = Artwork.create! :title => 'Vampire', :description => "Description for vampire artwork.", :image => File.open('db/seed_images/vampire.jpg'), :medium => [medium[1], medium[2]]

        show1 = Show.new :name => 'Pop Art', :date => '2010-9-15 12:00:00', :building => "MOMA", :address=> "400 Main Street; Columbus, OH", :show_type => "Gallery"
        show2 = Show.new :name => 'Magic Realism', :date => '2018-12-1 22:00:00', :building => 'Dayton Art Museum', :address => '1807 Broad Court Circle; Dayton OH', :show_type => "Gallery"
        show3 = Show.new :name => 'AWA', :date => '2018-4-7 17:00:00', :building => 'Sheraton Hotel', :address => '4000 Airport Way; Atlanta, GA', :show_type => 'Convention'

        shows = [show1, show2, show3]
        shows.each { |show| show.save }
    end
end
