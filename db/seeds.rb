# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require 'factory_girl'

# tumblr posts done before website was made:
tumblr_ids = [15570718881, 12843788442, 12566085628, 12565986211, 12565644328, 8924897274, 8924811031, 7725636552, 7023741329, 6995279618, 6972767226, 6972754947, 6972714902, 6972703457, 6972693030, 6972565024, 6972544725, 6705622531, 6705510647, 6705437508, 6705456664, 6703876941, 6703822783, 6703794561, 6703739017, 6703703911, 6702932028]
tumblr_ids.each do |id|
    tumble = AutoTumbles.new :tumble_id => id
    tumble.save
end

tweet_ids = [112552271451127808, 165236933075808256]
tweet_ids.each do |id|
    tweet = AutoTweets.new :tweet_id => id
    tweet.save
end

if Rails.env.development? or Rails.env.test?

    User.create :username => 'holly', :email => 'holly@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd', :privilege => 1
    User.create :username => 'logainsrequiem', :email => 'logainsrequiem@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd'

    tags = [ Tag.new(:name => "BDSM"), Tag.new(:name => "Butterflies")]

    tags.each { |tag| tag.save }

    medium = [ Medium.new(:name => "Colored Pencil"), Medium.new(:name => "Ink"), Medium.new( :name => "Water Color") ]
    medium.each { |media| media.save }

    prints1 = [ 
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 5.00, :size_name => "small", :material => "photopaper", :dimensions => "5x7"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 20.00, :size_name => "medium", :material => "photopaper", :dimensions => "8x11"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 50, :size_name => "large", :material => "photopaper", :dimensions => "16x20"),
                Print.new(:is_sold_out => false, :is_on_show => :true, :price => 800.00, :size_name => "original", :material => "original", :dimensions => "14x19"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 20.00, :size_name => "small", :material => "canvas", :dimensions => "5x7"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 60.00, :size_name => "medium", :material => "canvas", :dimensions => "8x11"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 90.00, :size_name => "large", :material => "canvas", :dimensions => "16x20")
            ]


    prints2 = [ 
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 5.00, :size_name => "small", :material => "photopaper", :dimensions => "5x7"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 20.00, :size_name => "medium", :material => "photopaper", :dimensions => "11x14"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 50.00, :size_name => "large", :material => "photopaper", :dimensions => "12x18"),
                Print.new(:is_sold_out => false, :is_on_show => :true, :price => 800.00, :size_name => "original", :material => "original", :dimensions => "22x24"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 20.00, :size_name => "small", :material => "canvas", :dimensions => "5x7"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 60.00, :size_name => "medium", :material => "canvas", :dimensions => "11x14"),
                Print.new(:is_sold_out => false, :is_on_show => :false, :price => 90.00, :size_name => "large", :material => "canvas", :dimensions => "12x18")
            ]
    (prints1+prints2).each {|print| print.save}


    art1 = Artwork.new :title => 'Butterfly', :description => "The wings of the butterfly caused a typhoon halfway across the world", :image => File.open('db/seed_images/butterfly.jpg'), :prints => prints1, :tags => [ tags[0], tags[1] ], :medium => [ medium[0], medium[1] ]
    art1.save!
    


    art2 = Artwork.new :title => 'Vampire', :description => "Description for vampire artwork.", :image => File.open('db/seed_images/vampire.jpg'), :prints => prints2, :medium => [medium[1], medium[2]]

    artworks = [art1, art2]
    artworks.each { |artwork| artwork.save }

    lesson1 = Lesson.new :name => 'Seeing as an Artist', :date => '2012-1-15 18:00:00', :free_spots => 5, :description => 'Learn how to see texture, composition, and shapes that make up the world around us.'
    lesson2 = Lesson.new :name => 'Coloring 101', :date => '2012-2-1 10:31:22', :free_spots => 0, :description => 'How to use color to make things extra pretty.'
    lesson3 = Lesson.new :name => 'Painting the Nude Body', :date => '2012-6-30 12:00:00', :free_spots => 15, :description => 'Drawing from a model, we shall take a keen eye to human anatomy'
    lesson4 = Lesson.new :name => 'Critters: Drawing Our Furry Friends.', :date => '2012-9-21 23:59:59', :free_spots => 0, :description => 'Learning how to handle texture of various furs from that of horses to otters to cats.'
    
    lessons = [lesson1, lesson2, lesson3, lesson4]
    lessons.each { |lesson| lesson.save }

    show1 = Show.new :name => 'Pop Art', :date => '2010-9-15 12:00:00', :building => "MOMA", :address=> "400 Main Street; Columbus, OH", :show_type => "Gallery"
    show2 = Show.new :name => 'Magic Realism', :date => '2014-12-1 22:00:00', :building => 'Dayton Art Museum', :address => '1807 Broad Court Circle; Dayton OH', :show_type => "Gallery"
    show3 = Show.new :name => 'Frolicon', :date => '2013-4-7 17:00:00', :building => 'Sheraton Hotel', :address => '4000 Airport Way; Atlanta, GA', :show_type => 'Convention'

    shows = [show1, show2, show3]
    shows.each { |show| show.save }
end
