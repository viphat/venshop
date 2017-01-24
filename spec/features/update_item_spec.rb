require 'rails_helper'

describe 'Update Item', type: :feature do
  let(:item) { FactoryGirl.create(:item) }

  shared_examples_for 'not authorized error' do
    let(:user) { FactoryGirl.build(:user) }
    it 'shouldn\'t access create new Item page' do
      expect { visit edit_item_path(item) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'As an admin' do
    include_context 'login_as_admin'

    before(:each) do
      FactoryGirl.create_list(:category, 4)
      visit edit_item_path(item)
    end

    it 'should render properly breadcrumbs' do
      within('#breadcrumbs') do
        expect(page).to have_link('Home', href: root_path)
        expect(page.has_link?(item.category_name, href: category_path(item.category))).to be_truthy
      end
    end

    it 'should render item form correctly' do
      categories = Category.select(:category_name).pluck(:category_name)
      within('.item-panel') do
        expect(page).to have_content 'Edit Item'
        expect(page).to have_select('item_category_id', options: ['', *categories], selected: item.category_name)
      end
    end

    it 'should update successfully when params are correct' do
      new_price = item.price + 10.0
      within('.item-panel') do
        fill_in 'item[price]', with: new_price
      end
      click_button 'Update'
      expect(page).to have_content 'Item was updated successfully.'
      item.reload
      expect(item.price).to eq new_price
    end

    it 'should update successfully when params are correct' do
      new_price = -1.0
      within('.item-panel') do
        fill_in 'item[price]', with: new_price
      end
      click_button 'Update'
      expect(page).not_to have_content 'Item was updated successfully.'
      expect(page).to have_content 'Price must be greater than or equal to 0.0'
    end

  end

  context 'As a user' do
    include_context 'login_as_user'
    it_behaves_like 'not authorized error'
  end

  context 'As a guest' do
    it 'should required login to be able to edit an item' do
      visit edit_item_path(item)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
