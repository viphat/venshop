require 'rails_helper'

describe 'register page', type: :feature do

  PASSWORD = "123456"
  PASSWORD_CONFIRMATION = "123456"
  WRONG_PASSWORD_CONFIRMATION = "12345"

  let(:foo_user) { FactoryGirl.create(:user) }

  before(:each) do
    visit new_user_registration_path
  end

  define_method(:fill_in_registration_form) do |
      email: FFaker::Internet.email,
      name: FFaker::Name.name,
      password: PASSWORD,
      password_confirmation: PASSWORD_CONFIRMATION|

    fill_in 'user[email]', with: email
    fill_in 'user[name]', with: name
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password_confirmation
  end

  it 'should register successfully when all attributes are valid' do
    within('.register-panel') do
      fill_in_registration_form
    end
    click_button "Register"
    within('.alert') do
      expect(page).to have_content "You have signed up successfully."
    end
  end

  it 'should return errors when password and password confirmation do not match' do
    within('.register-panel') do
      fill_in_registration_form(password_confirmation: WRONG_PASSWORD_CONFIRMATION)
    end
    click_button "Register"
    within('.alert') do
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  it 'should return errors when email has been used' do
    foo_user.valid?
    within('.register-panel') do
      fill_in_registration_form(email: foo_user.email)
    end
    click_button "Register"
    within('.alert') do
      expect(page).to have_content "Email has already been taken"
    end
  end

end
