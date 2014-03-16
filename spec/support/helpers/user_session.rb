def login(as)
  activate_authlogic
  @user = FactoryGirl.create(as)
  UserSession.create(@user)
end

def login_step(as)
  if as.is_a? Symbol 
    @user = FactoryGirl.create(as, :username => :user1)
  else
    @user = as
  end

  visit login_path
  fill_in 'user_session_username', :with => @user.username
  fill_in 'user_session_password', :with => @user.password || 'abcd'

  click_button('Login')
end

def register_step(as)
  visit new_user_path

  fill_in 'user_username', :with => as.username
  fill_in 'user_email', :with => as.email
  fill_in 'user_password', :with => as.password
  fill_in 'user_password_confirmation', :with => as.password_confirmation
  
  click_button 'Register'
end
