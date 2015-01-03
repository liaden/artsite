require 'faker'

FactoryGirl.define do
  factory :artwork do |f|
    f.title { Faker::Lorem::words.join(' ') }
    f.description { Faker::Lorem::paragraphs.join('\n') }
    f.image { File.new('./spec/images/watercolor.jpg') }               
  end

  factory :artwork_in_medium, :parent => :artwork do |f|
    f.after(:create) do |a|
      FactoryGirl.create(:medium, :artworks => [a]) 
    end
  end

  factory :tagged_artwork, :parent => :artwork do |f|
    f.after(:create) { |a| FactoryGirl.create(:tag, :artworks => [a] ) }
  end

  factory :tagged_artwork_in_medium, :parent => :artwork do |f|
    f.after(:create) do |a|
      FactoryGirl.create(:tag, :artworks => [a])
      FactoryGirl.create(:medium, :artworks => [a])
    end
  end
end


