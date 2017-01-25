require 'rails_helper'

describe 'Create new item', type: :feature do

  shared_examples_for 'not authorized error' do
    let(:user) { FactoryGirl.build(:user)}
    it 'shouldn\'t access create new Item page' do
      expect { visit new_item_path }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'As an admin' do
    include_context 'login_as_admin'
    let(:valid_item) { FactoryGirl.build(:item) }
    let(:first_category_name) { Category.first.category_name }

    before(:each) do
      FactoryGirl.create_list(:category, 5)
      visit new_item_path
    end

    it 'should render properly breadcrumbs' do
      within('#breadcrumbs') do
        expect(page).to have_link('Home', href: root_path)
        expect(page).to have_content('Create New Item')
      end
    end

    it 'should render item form correctly' do
      categories = Category.select(:category_name).pluck(:category_name)
      within('.item-panel') do
        expect(page).to have_content 'Create New Item'
        expect(page).to have_select('item_category_id', options: ['', *categories])
      end
    end

    it 'should create new item when params are correct' do
      within('.item-panel') do
        fill_in 'item[item_name]', with: valid_item.item_name
        select first_category_name, from: 'item[category_id]'
        fill_in 'item[price]', with: valid_item.price
        fill_in 'item[description]', with: valid_item.description
      end
      click_button 'Create'
      expect(page).to have_content 'Item was created successfully.'
    end

    it 'shouldn\'t create new item when missing category' do
      within('.item-panel') do
        select first_category_name, from: 'item[category_id]'
        fill_in 'item[price]', with: valid_item.price
      end
      click_button 'Create'
      within('.alert-danger') do
        expect(page).to have_content 'Item name can\'t be blank'
      end
    end

    it 'shouldn\'t create new item when missing category' do
      within('.item-panel') do
        fill_in 'item[item_name]', with: valid_item.item_name
        fill_in 'item[price]', with: valid_item.price
      end
      click_button 'Create'
      within('.alert-danger') do
        expect(page).to have_content 'Category can\'t be blank'
      end
    end

    it 'shouldn\'t create new item when price is incorrect' do
      within('.item-panel') do
        fill_in 'item[item_name]', with: valid_item.item_name
        select first_category_name, from: 'item[category_id]'
        fill_in 'item[price]', with: -1.0
      end
      click_button 'Create'
      within('.alert-danger') do
        expect(page).to have_content 'Price must be greater than or equal to 0.0'
      end
    end

  end

  context 'As a user' do
    include_context 'login_as_user'
    it_behaves_like 'not authorized error'
  end

  context 'As a guest' do
    it 'should required login to be able to add new Item' do
      visit new_item_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
