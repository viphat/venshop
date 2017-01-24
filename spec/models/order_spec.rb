require 'rails_helper'

RSpec.describe Order, type: :model do
  include OrderHelper

  shared_examples_for 'check_absence_of_ordered_at' do
    include_context 'skip_order_callbacks'
    it { is_expected.to validate_absence_of(:ordered_at) }
  end

  shared_examples_for 'check_presence_of_ordered_at' do
    include_context 'skip_order_callbacks'
    it { is_expected.to validate_presence_of(:ordered_at) }
  end

  shared_examples_for 'check_absence_of_delivered_at' do
    include_context 'skip_order_callbacks'
    it { is_expected.to validate_absence_of(:delivered_at) }
  end

  shared_examples_for 'check_presence_of_delivered_at' do
    include_context 'skip_order_callbacks'
    it { is_expected.to validate_presence_of(:delivered_at) }
  end

  shared_examples_for '#create_sold_inventory_items' do |status|
    # Check custom callbacks - Create Inventory Items
    include_context 'create_a_valid_order'
    it 'must create sold inventory items' do
      expect(order.inventory_items.length).to be_zero
      order_item.valid?
      order.status = status
      expect{ order.save }.to change{ InventoryItem.sold.length }.by(1)
      expect(order.reload.inventory_items.length).to eq 1
    end
  end

  shared_examples_for '#destroy_sold_inventory_items' do |status|
    include_context 'create_a_valid_order'

    before(:each) do
      order_item.valid?
      order.status = :new
      order.save and order.reload
    end

    it 'must destroy sold inventory items' do
      expect(order.inventory_items.length).to eq 1
      order.status = status
      order.save and order.reload
      expect(order.inventory_items.length).to be_zero
    end

  end

  shared_examples_for '#has_at_least_one_order_item?' do |status|
    # check custom validation - has_at_least_one_order_item?
    include_context 'create_a_valid_order'

    it "#{status} order has at least one item" do
      order.status = status
      expect(order.valid?).to be_falsy
      order_item.valid?
      order.reload
      order.status = status
      expect(order.save).to be_truthy
    end

  end

  context 'check by shoulda matchers' do
    subject(:order) { FactoryGirl.build(:order) }
    include_context 'skip_order_callbacks'

    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:order_items) }
    it { is_expected.to have_many(:inventory_items).through(:order_items) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to accept_nested_attributes_for(:order_items) }

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:subtotal_price) }
    it { is_expected.to validate_numericality_of(:subtotal_price).is_greater_than_or_equal_to(0.0) }
    it { is_expected.to validate_presence_of(:total_price) }
    it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0.0) }

    it { is_expected.to enumerize(:status).in(:in_progress, :new, :preparing, :shipping,
                          :done, :cancel, :refunded)
                        .with_default(:in_progress) }
  end

  context 'in_progress order' do
    subject(:order) { FactoryGirl.build(:order) }
    it_behaves_like 'check_absence_of_ordered_at'
    it_behaves_like 'check_absence_of_delivered_at'
    it_behaves_like '#destroy_sold_inventory_items', :in_progress
  end

  context 'new order' do
    subject(:order) { FactoryGirl.build(:order, status: :new) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_absence_of_delivered_at'
    it_behaves_like '#has_at_least_one_order_item?', :new
    it_behaves_like '#create_sold_inventory_items', :new
  end

  context 'preparing order' do
    subject(:order) { FactoryGirl.build(:order, status: :preparing) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_absence_of_delivered_at'
    it_behaves_like '#has_at_least_one_order_item?', :preparing
  end

  context 'shipping order' do
    subject(:order) { FactoryGirl.build(:order, status: :shipping) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_absence_of_delivered_at'
    it_behaves_like '#has_at_least_one_order_item?', :shipping
  end

  context 'done order' do
    subject(:order) { FactoryGirl.build(:order, status: :done) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_presence_of_delivered_at'
    it_behaves_like '#has_at_least_one_order_item?', :done
  end

  context 'cancel order' do
    subject(:order) { FactoryGirl.build(:order, status: :cancel) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_absence_of_delivered_at'
    it_behaves_like '#destroy_sold_inventory_items', :cancel
  end

  context 'refunded order' do
    subject(:order) { FactoryGirl.build(:order, status: :refunded) }
    it_behaves_like 'check_presence_of_ordered_at'
    it_behaves_like 'check_presence_of_delivered_at'
    it_behaves_like '#destroy_sold_inventory_items', :refunded
  end

end
