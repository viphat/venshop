require 'rails_helper'

describe 'Update Profile', type: :feature do

  let(:user) { FactoryGirl.create(:user) }

  context 'As a guest' do
    it 'should required login to be able to update profile' do
      visit edit_user_profile_path(user)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'Can not update other profile user' do
    include_context 'login_as_user'

    it 'should raise error' do
      expect { visit edit_user_profile_path(user) }.to raise_error(Pundit::NotAuthorizedError)
    end

  end

  context 'As a user' do
    include_context 'login_as_user'

    before(:each) do
      visit edit_user_profile_path(current_user)
    end

    it 'should update username successfully' do
      new_name = FFaker::Name.name
      within('.profile-panel') do
        fill_in('user[name]', with: new_name)
      end
      click_button 'Update'
      expect(page).to have_content 'Profile updated.'
      current_user.reload
      expect(current_user.name).to eq new_name
    end

    it 'should update password successfully' do
      new_password = "12345678"
      within('.profile-panel') do
        fill_in('user[password]', with: new_password)
        fill_in('user[password_confirmation]', with: new_password)
      end
      click_button 'Update'
      expect(page).to have_content 'Profile updated.'
      current_user.reload
      expect(current_user.valid_password?(new_password)).to be true
    end

    it 'shouldn\'t update password if password and password do not match' do
      new_password = "12345678"
      password_confirmation = "123456"
      within('.profile-panel') do
        fill_in('user[password]', with: new_password)
        fill_in('user[password_confirmation]', with: password_confirmation)
      end
      click_button 'Update'
      expect(page).to have_content 'Password confirmation doesn\'t match Password'
      current_user.reload
      expect(current_user.valid_password?(new_password)).to be false
    end

  end

end
