require 'rails_helper'

describe 'show item page', type: :feature do
  include FeaturesHelper

  let(:foo_item) { FactoryGirl.create(:item) }

  it 'should render properly breadcrumbs' do
    visit item_path(foo_item)
    within('#breadcrumbs') do
      expect(page).to have_link('Home', href: root_path)
      expect(page.has_link?(foo_item.category_name, href: category_path(foo_item.category))).to be_truthy
      expect(page).to have_content("Item ID #{foo_item.id}")
    end
  end

  context 'As a guest' do

    before(:each) do
      visit item_path(foo_item)
    end

    it 'can see an item with its attributes' do
      bar_item = FactoryGirl.create(:item)
      within('.item-page') do
        expect(page).to have_content(foo_item.item_name)
        expect(page.has_xpath?("//img[@alt='#{foo_item.item_name}' and @src='#{foo_item.item_image.url(:large)}']")).to be_truthy
        expect(page).to have_content(foo_item.id)
        expect(page).to have_content(foo_item.price)
        expect(page).to have_content(foo_item.created_at.strftime('%m/%d/%Y'))
        expect(page).not_to have_content(bar_item.item_name)
        expect(page).not_to have_link('Edit', href: edit_item_path(foo_item))
      end
    end

  end # Context 'As a guest'

  context 'As an admin' do
    include_context 'login_as_admin'
    it 'can see an edit button' do
      visit item_path(foo_item)
      expect(page).to have_link('Edit', href: edit_item_path(foo_item))
    end
  end

  context 'As an user' do
    include_context 'login_as_user'
    it 'can\'t see an edit button' do
      visit item_path(foo_item)
      expect(page).not_to have_link('Edit', href: edit_item_path(foo_item))
    end
  end

end
