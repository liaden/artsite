Given /^I am not logged in$/ do
end

Given /^I am logged in as Holly$/ do 
    User.create! :username => 'holly', :email => 'holly@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd', :privilege => 1
    page.visit '/login'
    page.fill_in 'user_session_username', :with => 'holly'
    page.fill_in 'user_session_password', :with => 'abcd'
    page.click_button 'Login'
    page.should have_content("Login successful")
end

Given /^I am logged in as user$/ do
    User.create! :username => 'user1', :email => 'user1@archaicsmiles.com', :password => 'abcd', :password_confirmation => 'abcd'
    page.visit '/login'
    page.fill_in 'user_session_username', :with => 'user1'
    page.fill_in 'user_session_password', :with => 'abcd'
    page.click_button 'Login'
    page.should have_content("Login successful")
end
