require 'factory_girl'

FactoryGirl.define do
  factory :supply do
    name 'mop'
    category 'brushes'
    description { Faker::Lorem::sentences(5).join('') }
    short_description { Faker::Lorem::words(5).join('') }
    referral_url 'http://www.dickblick.com/products/isabey-original-siberian-blue-squirrel-quill-mop-series-6234/'
  end
end
