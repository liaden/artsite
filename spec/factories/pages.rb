require 'factory_girl'

FactoryGirl.define do
  factory :page do
    name "MyString"
    content "MyText"
    page_type "tutorial"
  end
end
