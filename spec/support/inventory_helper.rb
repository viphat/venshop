module InventoryItemHelper

  RSpec.shared_context 'skip_inventory_item_callbacks' do
    before do
      # Skip some callbacks that can make tests failed
      InventoryItem.any_instance.stub(:set_quantity)
      InventoryItem.any_instance.stub(:set_item_id)
      InventoryItem.any_instance.stub(:check_with_order_item_quantity?)
    end

    after do
      InventoryItem.any_instance.unstub(:set_quantity)
      InventoryItem.any_instance.unstub(:set_item_id)
      InventoryItem.any_instance.unstub(:check_with_order_item_quantity?)
    end
  end

end
