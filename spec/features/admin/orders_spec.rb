require 'rails_helper'

describe 'Admin::Orders#Index', type: :feature do
  include OrderHelper

  describe 'As a user' do
    include_context 'login_as_user'

    it 'should raise error when user try to visit' do
      expect { visit admin_orders_path }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'As an admin' do
    include_context 'login_as_admin'
    include_context 'preparing_data_for_manage_orders'

    let(:first_page_orders) { Order.newest.first(Order::PAGE_SIZE) }
    let(:oldest_order) { Order.newest.last }

    it 'should render orders management 1st page correctly' do
      visit admin_orders_path

      within('.orders-panel') do
        expect(page).to have_content 'Manage Orders'
      end

      first_page_orders.each do |order|
        within("#order-#{order.id}") do
          expect(page).to have_content order.id
          expect(page).to have_content order.user.name
          expect(page).to have_content I18n.t("order.status.#{order.status}")
          expect(page).to have_link "Details", admin_order_path(order)
        end
      end

      expect(page).not_to have_css("tr#order-#{oldest_order.id}")

    end

    it 'should render orders management 2nd page correctly' do

      visit admin_orders_path(page: 2)

      first_page_orders.each do |order|
        expect(page).not_to have_css("tr#order-#{order.id}")
      end

      within("#order-#{oldest_order.id}") do
        expect(page).to have_content oldest_order.id
        expect(page).to have_content oldest_order.user.name
        expect(page).to have_content I18n.t("order.status.#{oldest_order.status}")
        expect(page).to have_link "Details", admin_order_path(oldest_order)
      end

    end

  end

end
