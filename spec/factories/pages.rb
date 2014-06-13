require 'factory_girl'

FactoryGirl.define do
  factory :page do
    name "MyString"
    content "MyText"
    page_type "tutorial"
  end

  factory :tutorial, :parent => :page do
  end

  factory :video, :parent => :page do
    page_type 'video'
    content '<iframe width="560" height="315" src="//www.youtube.com/embed/g857UNIKQsM" frameborder="0" allowfullscreen></iframe>'
  end
end
