require 'rails_helper'

describe 'home page', :type => :feature do

  define_method(:check_links_on_header) do |
      login_is_visible: true,
      register_is_visible: true,
      logout_is_visible: true,
      update_profile_is_visible: true|

    within('nav.navbar') do
      expect(page.has_link?("Login", href: new_user_session_path)).to be login_is_visible
      expect(page.has_link?("Register", href: new_user_registration_path)).to be register_is_visible
      expect(page.has_link?("Logout", href: destroy_user_session_path)).to be logout_is_visible
      expect(page.has_link?("Update Profile", href: new_user_update_profile_path)).to be update_profile_is_visible
    end

  end

  it "should have at most #{Item::NEWEST_ITEMS_LIMIT} new items" do
    FactoryGirl.create_list(:item, Item::NEWEST_ITEMS_LIMIT + 1)
    newest_items = Item.newest.select(:item_name).pluck(:item_name)
    expect(newest_items).not_to be_empty
    visit '/'
    Item::NEWEST_ITEMS_LIMIT.times do
      expect(page).to have_content(newest_items.shift)
    end
    expect(page).not_to have_content(newest_items.last)
  end

  it "should have all categories's link on sidebar" do
    NUM_OF_CATEGORIES = 5
    FactoryGirl.create_list(:category, NUM_OF_CATEGORIES)
    visit '/'
    within('#sidebar') do
      Category.first(NUM_OF_CATEGORIES) do |category|
        expect(page).not_to have_category_path(category)
      end
    end
  end

  context 'As a guest' do
    before(:each) do
      visit '/'
    end

    it 'can see login and register button on header' do
      check_links_on_header(logout_is_visible: false, update_profile_is_visible: false)
    end
  end

  context 'As a user' do
    include_context 'login_as_user'

    before(:each) do
      visit '/'
    end

    it 'can see logout and update profile button' do
      check_links_on_header(login_is_visible: false, register_is_visible: false)
    end

    it 'can logout successfully' do
      within('nav.navbar') do
        click_link("Logout")
      end
      expect(page).to have_content "Signed out successfully."
      check_links_on_header(logout_is_visible: false, update_profile_is_visible: false)
    end

  end

end
