require_relative './shopping_cart_helper.rb'
module CheckoutHelper

  include ShoppingCartHelper

  RSpec.shared_context 'preparing_data_for_checkout' do
    include_context 'added_items_to_cart'
  end

end
