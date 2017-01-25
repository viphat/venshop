require 'rails_helper'

describe 'Admin::Orders#Show,Update,Destroy', type: :feature do
  include OrderHelper
  include_context 'preparing_data_for_manage_orders'
  let(:order) { Order.with_status(:new).first }

  describe 'As a user' do
    include_context 'login_as_user'
    it 'should raise error when user try to visit' do
      expect { visit admin_order_path(order) }.to raise_error(Pundit::NotAuthorizedError)
    end

  end

  describe 'As an admin' do
    include_context 'login_as_admin'

    before(:each) do
      visit admin_order_path(order)
    end

    it 'should show an order details correctly' do
      within('.order-panel') do
        expect(page).to have_content "Order Details - #{order.id}"
        expect(page).to have_content order.user.name
        expect(page).to have_content order.order_items.first.item.item_name
        expect(page).to have_content order.total_price
        expect(page).to have_content order.subtotal_price
        unless order.ordered_at.nil?
          expect(page).to have_content order.ordered_at.strftime('%m/%d/%Y')
        end
        unless order.delivered_at.nil?
          expect(page).to have_content order.delivered_at.strftime('%m/%d/%Y')
        end
        expect(page).to have_select('order[status]', selected: order.status)
      end
    end

    it 'can update order status successfully' do
      within('.order-panel') do
        select 'done', from: 'order[status]'
      end
      click_button 'Update'
      expect(page).to have_content 'The order was updated successfully.'
      order.reload
      expect(order.status).to eq :done
      expect(order.delivered_at).not_to eq nil
    end

    it 'can delete order successfully' do
      expect{click_link 'Delete'}.to change { Order.count }.by(-1)
      expect(page).to have_content 'The order was destroyed successfully.'
    end

  end

end
