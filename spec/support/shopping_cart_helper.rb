module ShoppingCartHelper

  RSpec.shared_context 'preparing_data_for_shopping_cart' do

    let(:items) { Item.all }
    let(:item) { Item.first }

    before(:each) do
      # Create Items
      FactoryGirl.create_list(:item, 5)
      # Import Items
      items.each do |item|
        item.inventory_items.create(quantity: 5)
      end
    end

  end

  RSpec.shared_context 'added_items_to_cart' do
    include_context 'preparing_data_for_shopping_cart'

    let(:order) { current_user.orders.last }
    let(:first_item) { Item.first }
    let(:num_of_first_item_purchased) { 1 }
    let(:first_order_item) { current_user.order_items.find_by(item: first_item) }

    let(:second_item) { Item.second }
    let(:num_of_second_item_purchased) { 2 }
    let(:second_order_item) { current_user.order_items.find_by(item: second_item) }

    before(:each) do
      added_item_to_cart(first_item, num_of_first_item_purchased)
      added_item_to_cart(second_item, num_of_second_item_purchased)
    end

  end

  def added_item_to_cart(item, quantity)
    visit item_path(item)
    fill_in 'order_item[quantity]', with: quantity
    click_button 'Add to Cart'
  end

end
