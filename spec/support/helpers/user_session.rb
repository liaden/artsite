def login(as)
    activate_authlogic
    @user = FactoryGirl.create(as)
    UserSession.create(@user)
end

def login_step(as)
    FactoryGirl.create(:artist_statement)
    @user = FactoryGirl.create(as, :username => :user1)

    visit login_path
    fill_in 'user_session_username', :with => @user.username
    fill_in 'user_session_password', :with => 'abcd'

    click_button('Login')
end
