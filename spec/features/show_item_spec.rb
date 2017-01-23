require 'rails_helper'

describe 'show item page', :type => :feature do
  include FeaturesHelper

  let(:foo_item) { FactoryGirl.create(:item) }

  before(:each) do
    visit item_path(foo_item)
  end

  it 'should render properly breadcrumbs' do
    within('#breadcrumbs') do
      expect(page).to have_link('Home', href: root_path)
      expect(page.has_link?("#{foo_item.category_name}", href: category_path(foo_item.category))).to be_truthy
      expect(page).to have_content("Item ID #{foo_item.id}")
    end
  end

  context 'As guest' do

    it 'can view an item with its attributes' do
      bar_item = FactoryGirl.create(:item)
      within(".item-page") do
        expect(page).to have_content(foo_item.item_name)
        expect(page.has_xpath?("//img[@alt='#{foo_item.item_name}' and @src='#{foo_item.item_image.url(:large)}']")).to be_truthy
        expect(page).to have_content(foo_item.id)
        expect(page).to have_content(foo_item.price)
        expect(page).to have_content(foo_item.created_at.strftime('%m/%d/%Y'))
        expect(page).not_to have_content(bar_item.item_name)
      end
    end

  end # Context 'As guest'

  context 'As user' do
    include_context 'login_as_user'

  end

end
