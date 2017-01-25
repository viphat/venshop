require 'rails_helper'

describe 'Shopping Cart', type: :feature do
  include ShoppingCartHelper
  include_context 'login_as_user'

  describe 'Add Item to Cart' do
    include_context 'preparing_data_for_shopping_cart'

    let(:order_item) { current_user.order_items.find_by(item: item) }

    it 'should added to cart successfully' do
      expect { added_item_to_cart(item, 1) }.to change{current_user.order_items.where(item: item).count }.by(1)
      expect(page).to have_content 'The item was added to cart successfully'
    end

    it 'should added to cart failed due to out of stock' do
      expect { added_item_to_cart(item, 15) }.not_to change{current_user.order_items.where(item: item).count }
      expect(page).to have_content 'The item was unable to add to cart'
    end

    it 'should update quantity if we\'ve already added this item to cart before' do
      added_item_to_cart(item, 1)
      expect(order_item.quantity).to eq 1
      expect { added_item_to_cart(item, 2) }.not_to change{current_user.order_items.where(item: item).count }
      expect(page).to have_content 'The item was added to cart successfully'
      order_item.reload
      expect(order_item.quantity).to eq 3
    end

  end

  describe 'Empty cart' do

    before(:each) do
      visit show_cart_path
    end

    it 'should render empty message' do
      within('.cart-panel') do
        expect(page).to have_content 'Shopping Cart'
        expect(page).to have_content 'Your cart is empty'
        expect(page).to have_link 'Back To Home', root_path
        expect(page).not_to have_link 'Checkout', new_checkout_path
      end
    end

  end

  describe 'Showing cart' do
    include_context 'added_items_to_cart'
    let(:new_quantity) { 5 }
    let(:out_of_stock_quantity) { 15 }

    before(:each) do
      visit show_cart_path
    end

    it 'should render user\'s cart correctly' do

      within('.cart-panel') do
        expect(page).to have_content 'Shopping Cart'
        expect(page).not_to have_content 'Your cart is empty'
        expect(page).not_to have_link 'Back To Home', root_path
        expect(page).to have_content first_item.item_name
        expect(page).to have_content second_item.item_name
      end

    end

    it 'should render total row correctly' do

      within('.total-row') do
        expect(page).to have_content "Subtotal: $#{order.subtotal_price}"
        expect(page).to have_content "Shipping Cost: $#{Order::SHIPPING_COST}"
        expect(page).to have_content "Total: $#{order.total_price}"
        expect(page).to have_link 'Checkout', new_checkout_path
      end

    end

    it 'should render each order item correctly' do

      within(".order-item-#{first_order_item.id}") do
        expect(page).to have_selector("input[type=number][value='#{first_order_item.quantity}']")
        expect(page).to have_selector("input[type=submit][value='Update']")
        expect(page).to have_link 'Remove', order_item_path(first_order_item)
      end

      within(".order-item-#{second_order_item.id}") do
        expect(page).to have_selector("input[type=number][value='#{second_order_item.quantity}']")
        expect(page).to have_selector("input[type=submit][value='Update']")
        expect(page).to have_link 'Remove', order_item_path(first_order_item)
      end

    end

    it 'should update order_item\'s quantity successfully' do
      expect(first_order_item.quantity).to eq num_of_first_item_purchased
      within(".order-item-#{first_order_item.id}") do
        fill_in 'order_item[quantity]', with: new_quantity
        click_button 'Update'
      end
      expect(page).to have_content 'Update successfully'
      expect(first_order_item.reload.quantity).to eq new_quantity
      expect(second_order_item.reload.quantity).to eq num_of_second_item_purchased
    end

    it 'should update order_item\'s quantity failed when item is out of stock' do
      expect(first_order_item.quantity).to eq num_of_first_item_purchased
      within(".order-item-#{first_order_item.id}") do
        fill_in 'order_item[quantity]', with: out_of_stock_quantity
        click_button 'Update'
      end
      expect(page).to have_content 'Update failed'
      expect(first_order_item.reload.quantity).to eq num_of_first_item_purchased
      expect(second_order_item.reload.quantity).to eq num_of_second_item_purchased
    end

    it 'should remove order item successfully' do
      expect do
        within(".order-item-#{first_order_item.id}") do
          click_link 'Remove'
        end
      end.to change { OrderItem.count }.by(-1)
      expect(page).to have_content 'Remove successfully'
    end

  end

end
