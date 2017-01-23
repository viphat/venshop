require 'rails_helper'

describe 'login page', type: :feature do

  CORRECT_PASSWORD = "123456"
  WRONG_PASSWORD = "abcxyz"

  let(:user) { FactoryGirl.create(:user, password: CORRECT_PASSWORD) }

  before(:each) do
    visit new_user_session_path
  end

  it 'should login successfully with correct email & password' do
    within('.login-panel') do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: CORRECT_PASSWORD
    end
    click_button 'Login'
    within('.alert') do
      expect(page).to have_content "Signed in successfully."
    end
  end

  it 'can\'t login with incorrect email or password' do
    within('.login-panel') do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: WRONG_PASSWORD
    end
    click_button 'Login'
    within('.alert') do
      expect(page).not_to have_content "Signed in successfully."
    end
  end

end
