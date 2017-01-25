module OrderItemHelper

  RSpec.shared_context 'skip_order_item_callbacks' do
    before do
      # Skip some callbacks that can make tests failed
      OrderItem.any_instance.stub(:set_price)
    end

    after do
      OrderItem.any_instance.unstub(:set_price)
    end
  end

end
