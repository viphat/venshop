require 'rails_helper'

describe 'Admin::Items#Index,Update', type: :feature do

  describe 'As a user' do
    include_context 'login_as_user'
    let(:item) { FactoryGirl.create(:item) }
    it 'should raise error when user try to visit' do
      expect { visit admin_items_path }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'As an admin' do
    include_context 'login_as_admin'

    context '#index' do
      let(:first_page_items) { Item.newest.first(Item::ITEMS_ON_ADMIN_PAGE) }
      let(:oldest_item) { Item.newest.last }

      before(:each) do
        (Item::ITEMS_ON_ADMIN_PAGE + 1).times do
          last_item = FactoryGirl.create(:item)
          Timecop.travel(last_item.created_at + 1.second)
        end
      end

      it 'should render 1st page correctly' do
        visit admin_items_path
        within('.items-panel') do
          expect(page).to have_content 'Manage Items'
        end
        first_page_items.each do |item|
          within("#item-#{item.id}") do
            expect(page).to have_content item.item_name
          end
        end
        expect(page).not_to have_css("tr#item-#{oldest_item.id}")
      end

      it 'should render 2nd page correctly' do
        visit admin_items_path(page: 2)
        first_page_items.each do |item|
          expect(page).not_to have_css("tr#item-#{item.id}")
        end
        within("#item-#{oldest_item.id}") do
          expect(page).to have_content oldest_item.item_name
        end
      end
    end

    context '#update' do

      let(:item) { FactoryGirl.create(:item) }
      before(:each) do
        item.valid?
        visit admin_items_path
      end

      it 'should import successfully.' do
        within("#item-#{item.id}") do
          fill_in 'item[import_quantity]', with: 10
          click_button 'Import'
        end
        expect(page).to have_content "Import Item #{item.item_name} successfully."
        expect(item.quantity).to eq 10
        within("#item-#{item.id}") do
          fill_in 'item[import_quantity]', with: 5
          click_button 'Import'
        end
        expect(page).to have_content "Import Item #{item.item_name} successfully."
        expect(item.quantity).to eq 15
      end

      it 'should import failed.' do
        within("#item-#{item.id}") do
          fill_in 'item[import_quantity]', with: 0
          click_button 'Import'
        end
        expect(page).to have_content "Import Item #{item.item_name} failed."
        expect(item.quantity).to eq 0
        within("#item-#{item.id}") do
          fill_in 'item[import_quantity]', with: -5
          click_button 'Import'
        end
        expect(page).to have_content "Import Item #{item.item_name} failed."
        expect(item.quantity).to eq 0
      end

    end

  end


end
