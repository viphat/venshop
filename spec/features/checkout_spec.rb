require 'rails_helper'

Sidekiq::Testing.inline! # Runs the job immediately instead of enqueuing it.

describe 'Checkout Page', type: :feature do
  include CheckoutHelper
  include_context 'login_as_user'

  define_method(:fill_in_and_expect_checkout_successfully) do |address|
    within('.checkout-panel') do
      fill_in 'checkout[address]', with: address
      click_button 'Save'
    end
    expect(page).to have_content 'Checkout successfully'
    expect(current_user.reload.address).to eq address
    expect(order.shipping_address).to eq address
  end

  describe 'User with an empty cart' do
    before(:each) do
      visit new_checkout_path
    end

    it 'should render empty message' do
      within('.checkout-panel') do
        expect(page).to have_content 'Checkout'
        expect(page).to have_content 'Your cart is empty'
        expect(page).to have_link 'Back To Home', root_path
      end
    end
  end

  describe 'User with some items in cart' do
    include_context 'preparing_data_for_checkout'
    let(:address) { FFaker::Address.street_address }
    let(:new_address) { FFaker::Address.street_address }

    context 'user with address' do

      before(:each) do
        current_user.update_attributes(address: address)
        visit new_checkout_path
      end

      it 'should render user current address' do
        within('.checkout-panel') do
          expect(page).to have_selector("input[type=text][value='#{address}']")
        end
      end

      it 'should update user current address' do
        expect(current_user.address).to eq address
        fill_in_and_expect_checkout_successfully(new_address)
      end

    end

    context 'user without address' do

      before(:each) do
        visit new_checkout_path
      end

      it 'should fill in address and checkout successfully' do

        fill_in_and_expect_checkout_successfully(address)
      end

      it 'should checkout failed if user does not declare shipping address' do
        within('.checkout-panel') do
          fill_in 'checkout[address]', with: ''
          click_button 'Save'
        end
        expect(page).to have_content 'Checkout failed'
      end

    end

    context 'check mailer is working?' do

      before(:each) do
        visit new_checkout_path
      end

      it 'should send email to user after finishing checkout' do
        expect do
          within('.checkout-panel') do
            fill_in 'checkout[address]', with: address
            click_button 'Save'
          end
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

  end

  describe 'When user want to cancel order' do
    include_context 'preparing_data_for_checkout'

    before(:each) do
      visit new_checkout_path
    end

    it 'should cancel order successfully' do
      within('.checkout-panel') do
        click_link 'Cancel Order'
      end
      expect(page).to have_content 'Your order have been canceled'
      expect(order.status).to eq :cancel
    end

  end



end
