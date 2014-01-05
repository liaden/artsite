FactoryGirl.define do
  factory :article do
    title "MyString"
    content "MyText"
  end

  factory :artist_statement, :parent => :article do
    title :artist_statement
  end
end
