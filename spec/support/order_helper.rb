require_relative './item_helper.rb'

module OrderHelper
  include ItemHelper

  def create_an_order(user, status)
    order = Order.new(user: user)
    item = Item.all.sample
    order_item = order.order_items.new(item: item, quantity: 1)
    order_item.save and order.save
    order.update_attributes(status: status)
    order
  end

  RSpec.shared_context 'preparing_data_for_view_orders' do

    include_context 'preparing_items' do
      let(:number_of_creating_items) { 20 }
      let(:quantity_of_each_item) { 100 }
    end

    let(:user) { FactoryGirl.create(:user) }

    let(:other_user) { FactoryGirl.create(:user) }

    before(:each) do
      order = create_an_order(user, :in_progress)
      (Order::PAGE_SIZE + 1).times do
        Timecop.travel(order.created_at + 1.day) do
          order = create_an_order(user, [:new,:done].sample)
        end
      end
      create_an_order(other_user, :done)
    end

  end

  RSpec.shared_context 'create_a_valid_order' do
    let(:item) { FactoryGirl.create(:item) }
    let(:imported_item) { import_item(item: item, quantity: 10) }
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
