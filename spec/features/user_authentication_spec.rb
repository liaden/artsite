require 'spec_helper'

describe 'User Authentication' do
  let(:visits_home_page) do
    FactoryGirl.create(:artwork)
    FactoryGirl.create(:show)
  end

  describe 'user registration' do
    it 'registers user' do
      visits_home_page

      visit new_user_path
      register_step(FactoryGirl.build(:user))

      page.should have_content('Account successfully created')
    end

    it 'logs new user in' do
      visits_home_page

      register_step(FactoryGirl.build(:user))

      within('#main-nav') do
        page.should have_content('Logout')
      end
    end
    
    it 'shows errors for creating duplicate user' do
      register_step(FactoryGirl.create(:user))

      within('#form-error') do
        page.should have_content('Username')
      end
    end

    it 'shows validation errors for bad data' do
      @user = FactoryGirl.build(:user)
      @user.password_confirmation = 'WRONG'

      register_step(@user)

      within('#form-error') do
        page.should have_content('Password')
      end
    end
  end

  describe 'as user' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'login' do
      
      context 'user successfully logs in' do
        it 'user successfully logs in' do
          visits_home_page
          login_step(user)
          page.should have_content('successfully logged in')
        end

        it 'nav bar does not show login/register' do
          visits_home_page
          login_step(user)
          within('#main-nav') do
            page.should_not have_content('Login')
            page.should_not have_content('Register')
          end
        end
      end

      it 'fails login with unknown username' do
        user.username = 'WRONG'
        login_step(user)

        within('#form-error') do
          page.should have_content('Username')
        end
      end

      it 'fails login with bad password' do
        user.password = 'WRONG'
        login_step(user)

        within('#form-error') do
          page.should have_content('Password')
        end
      end
    end

    describe 'logout' do
      it 'after logout, it shows login page' do
        visits_home_page

        login_step(:user)
        click_link 'Logout'

        page.should have_content('Login')
      end
    end
  end
end
