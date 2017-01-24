module OrderHelper

  RSpec.shared_context 'create_a_valid_order' do
    let(:item) { FactoryGirl.create(:item) }

    let(:imported_item) { FactoryGirl.create(:inventory_item, item: item)}

    let(:order) { FactoryGirl.create(:order) }

    let(:order_item) { FactoryGirl.create(:order_item, item: item, order: order) }

    let(:sold_item) do
      order_item.valid?
      order.update_attributes(status: :new)
      order.inventory_items.first
    end

    before(:each) do
      imported_item.valid?
    end
  end

  RSpec.shared_context 'skip_order_callbacks' do
    before do
      # Skip some callbacks that can make tests failed
      Order.any_instance.stub(:set_ordered_at)
      Order.any_instance.stub(:set_delivered_at)
      Order.any_instance.stub(:set_subtotal_price)
      Order.any_instance.stub(:set_total_price)
      Order.any_instance.stub(:check_subtotal_with_total?)
    end

    after do
      Order.any_instance.unstub(:set_ordered_at)
      Order.any_instance.unstub(:set_delivered_at)
      Order.any_instance.unstub(:set_subtotal_price)
      Order.any_instance.unstub(:set_total_price)
      Order.any_instance.unstub(:check_subtotal_with_total?)
    end
  end

end
