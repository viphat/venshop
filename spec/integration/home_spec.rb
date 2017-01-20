require 'rails_helper'

describe 'home page', :type => :feature do

  it "should have at most #{Item::NEWEST_ITEMS_LIMIT} new items" do
    FactoryGirl.create_list(:item, Item::NEWEST_ITEMS_LIMIT + 1)
    newest_items = Item.newest.pluck(:item_name)
    expect(newest_items).not_to be_empty
    visit '/'
    Item::NEWEST_ITEMS_LIMIT.times do
      expect(page).to have_content(newest_items.shift)
    end
    expect(page).not_to have_content(newest_items.last)
  end

  it "should have all categories" do


  end

end
