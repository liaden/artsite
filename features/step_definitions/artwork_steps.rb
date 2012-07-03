
When /^I visit (.*)$/ do |url|
    visit url
end

When /^I create an artwork$/ do
    page.fill_in 'title', :with => 'test_title'
    page.fill_in 'description', :with => 'test_description'
    page.fill_in 'tags', :with => 'these,are,some,tags'
    page.fill_in 'mediums', :with => 'watercolor,ink'
end

Then /^(.*) should be rendered$/ do |url|
    text = page.body
    visit url
    text.should == page.body
end

Then /^(.*) new artwork is in the gallery$/ do |amount|
    if amount == 'no'
        Artwork.all.size.should == 0 
    else
        Artwork.all.size.should == amount
    end
end
