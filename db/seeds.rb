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

    # create the instance for unmatted and unframed
    Matte.create :size => 0, :matte_color => nil
    Frame.create :thickness => 0, :price_per_inch => 0, :depth => 0, :linear_inches => 0

    if Rails.env.development? or Rails.env.test?

        User.create :username => 'holly', :email => 'holly@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd', :privilege => 1
        User.create :username => 'logainsrequiem', :email => 'logainsrequiem@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd'

        tags = [ Tag.new(:name => "Feminism"), Tag.new(:name => "Butterflies")]

        tags.each { |tag| tag.save }

        medium = [ Medium.new(:name => "Colored Pencil"), Medium.new(:name => "Ink"), Medium.new( :name => "Water Color") ]
        medium.each { |media| media.save }

        art1 = Artwork.create! :title => 'Butterfly', :description => "The wings of the butterfly caused a typhoon halfway across the world", :image => File.open('db/seed_images/butterfly.jpg'), :tags => [ tags[0], tags[1] ], :medium => [ medium[0], medium[1] ]
        art1.save!
        prints1 = [ 
                    Print.photopaper(:price => 5.00, :size_name => "small", :dimensions => "5x7", :artwork => art1),
                    Print.photopaper(:price => 20.00, :size_name => "medium", :dimensions => "8x11", :artwork => art1),
                    Print.photopaper(:price => 50, :size_name => "large", :dimensions => "16x20", :artwork => art1),
                    Print.original(:price => 800.00, :dimensions => "14x19", :artwork => art1),
                    Print.canvas(:price => 20.00, :size_name => "small", :dimensions => "5x7", :artwork => art1),
                    Print.canvas(:price => 60.00, :size_name => "medium", :dimensions => "8x11", :artwork => art1),
                    Print.canvas(:price => 90.00, :size_name => "large", :dimensions => "16x20", :artwork => art1)
                ]


        art2 = Artwork.create! :title => 'Vampire', :description => "Description for vampire artwork.", :image => File.open('db/seed_images/vampire.jpg'), :medium => [medium[1], medium[2]]
        prints2 = [ 
                    Print.photopaper(:price => 5.00, :size_name => "small", :dimensions => "5x7", :artwork => art2),
                    Print.photopaper(:price => 20.00, :size_name => "medium", :dimensions => "11x14", :artwork => art2),
                    Print.photopaper(:price => 50.00, :size_name => "large", :dimensions => "12x18", :artwork => art2),
                    Print.original(:price => 800.00, :dimensions => "22x24", :artwork => art2),
                    Print.canvas(:price => 20.00, :size_name => "small", :dimensions => "5x7", :artwork => art2),
                    Print.canvas(:price => 60.00, :size_name => "medium", :dimensions => "11x14", :artwork => art2),
                    Print.canvas(:price => 90.00, :size_name => "large", :dimensions => "12x18", :artwork => art2)
                ]

        (prints1+prints2).each { |print| print.save! }

        lesson1 = Lesson.new :name => 'Seeing as an Artist', :date => '2012-1-15 18:00:00', :free_spots => 5, :description => 'Learn how to see texture, composition, and shapes that make up the world around us.'
        lesson2 = Lesson.new :name => 'Coloring 101', :date => '2012-2-1 10:31:22', :free_spots => 0, :description => 'How to use color to make things extra pretty.'
        lesson3 = Lesson.new :name => 'Painting the Nude Body', :date => '2012-6-30 12:00:00', :free_spots => 15, :description => 'Drawing from a model, we shall take a keen eye to human anatomy'
        lesson4 = Lesson.new :name => 'Critters: Drawing Our Furry Friends.', :date => '2012-9-21 23:59:59', :free_spots => 0, :description => 'Learning how to handle texture of various furs from that of horses to otters to cats.'
        
        lessons = [lesson1, lesson2, lesson3, lesson4]
        lessons.each { |lesson| lesson.save }

        show1 = Show.new :name => 'Pop Art', :date => '2010-9-15 12:00:00', :building => "MOMA", :address=> "400 Main Street; Columbus, OH", :show_type => "Gallery"
        show2 = Show.new :name => 'Magic Realism', :date => '2014-12-1 22:00:00', :building => 'Dayton Art Museum', :address => '1807 Broad Court Circle; Dayton OH', :show_type => "Gallery"
        show3 = Show.new :name => 'AWA', :date => '2013-4-7 17:00:00', :building => 'Sheraton Hotel', :address => '4000 Airport Way; Atlanta, GA', :show_type => 'Convention'

        shows = [show1, show2, show3]
        shows.each { |show| show.save }
    end
end
