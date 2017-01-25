require 'rails_helper'

describe 'View Your Orders', type: :feature do
  include OrderHelper

  include_context 'login_as_user'


  context 'empty page' do
    before(:each) do
      visit orders_path
    end

    it 'should render empty message' do
      within('.orders-panel') do
        expect(page).to have_content 'Your Orders'
        expect(page).to have_content 'You haven\'t have any orders yet.'
      end
    end

  end

  describe 'User has some orders before' do

    include_context 'preparing_data_for_view_orders' do
      let(:user) { current_user }
    end

    let(:first_page_orders) { current_user.orders.newest.without_status(:in_progress).first(Order::PAGE_SIZE) }
    let(:in_progress_order) { current_user.orders.with_status(:in_progress).first }
    let(:newest_order) { current_user.orders.newest.without_status(:in_progress).first }
    let(:oldest_order) { current_user.orders.newest.without_status(:in_progress).last }
    let(:other_user_order) { Order.where(user: other_user).first }

    context 'The 1st Page' do

      before(:each) do
        visit orders_path
      end

      it 'should render user\'s orders correctly' do

        within('.orders-panel') do
          expect(page).to have_content 'Your Orders'
        end

        first_page_orders.each do |order|
          within("#order-#{order.id}") do
            expect(page).to have_content order.id
            expect(page).to have_content order.total_price
            expect(page).to have_content I18n.t("order.status.#{order.status}")
            order.order_items.each do |order_item|
              expect(page).to have_content order_item.item.item_name
            end
          end
        end
        expect(page).not_to have_css("tr#order-#{oldest_order.id}")
      end

      it 'shoud not include other user\'s order' do
        expect(page).to have_css("tr#order-#{newest_order.id}")
        expect(page).not_to have_css("tr#order-#{other_user_order.id}")
      end

      it 'should not include in_progress order' do
        expect(page).not_to have_css("tr#order-#{in_progress_order.id}")
      end
    end

    context 'The 2nd Page' do
      before(:each) do
        visit orders_path(page: 2)
      end

      it 'should render correctly' do

        first_page_orders.each do |order|
          expect(page).not_to have_css("tr#order-#{order.id}")
        end

        within("#order-#{oldest_order.id}") do
          expect(page).to have_content oldest_order.id
          expect(page).to have_content oldest_order.total_price
          expect(page).to have_content I18n.t("order.status.#{oldest_order.status}")
          oldest_order.order_items.each do |order_item|
            expect(page).to have_content order_item.item.item_name
          end
        end


      end

    end

  end

end
