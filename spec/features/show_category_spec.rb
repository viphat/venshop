require 'rails_helper'

describe 'show category page', type: :feature do

  let(:category) { FactoryGirl.create(:category) }
  let(:other_category) { FactoryGirl.create(:other_category) }

  it 'should render properly breadcrumbs' do
    visit category_path(category)
    within('#breadcrumbs') do
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_content category.category_name
    end
  end

  context 'empty category' do
    it 'should render empty page' do
      visit category_path(category)
      expect(page).to have_content "#{category.category_name} doesn't have any items."
    end
  end

  context 'non-empty category' do

    let(:newest_item) { Item.newest.first }
    let(:oldest_item) { Item.newest.last }
    let(:first_page_items) { Item.newest.first(Category::ITEMS_LIMIT) }

    before(:each) do
      (Category::ITEMS_LIMIT + 1).times do
        item = FactoryGirl.create(:item, category: category)
        Timecop.travel(item.created_at + 5.seconds)
      end
    end

    it "should render at most #{Category::ITEMS_LIMIT} categor's items" do
      visit category_path(category)
      within('.category-page') do
        expect(page).to have_content category.category_name
        first_page_items.each do |item|
          expect(page).to have_link(item.item_name, href: item_path(item))
          expect(page).to have_content "Price: #{item.price}"
        end
        expect(page).to have_selector('.horizontal-item', count: Category::ITEMS_LIMIT)
        expect(page).not_to have_link(oldest_item.item_name, href: item_path(oldest_item))
      end
    end

    it 'should render correctly when I visit 2nd page' do
      visit category_path(id: category.id, page: 2)
      within('.category-page') do
        expect(page).to have_link(oldest_item.item_name, href: item_path(oldest_item))
        expect(page).to have_content "Price: #{oldest_item.price}"
        expect(page).to have_selector('.horizontal-item', count: 1)
        expect(page).not_to have_link(newest_item.item_name, href: item_path(newest_item))
      end
    end

  end
end
