require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  include OrderHelper
  include OrderItemHelper

  context 'check by shoulda matchers' do
    include_context 'skip_order_item_callbacks'

    subject(:order_item) { FactoryGirl.build(:order_item, unit_price: 0.0, total_price: 0.0) }

    it { is_expected.to belong_to(:order).inverse_of(:order_items) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to have_one(:inventory_item).dependent(:destroy) }
    it { is_expected.to delegate_method(:user).to(:order) }

    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:item) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0).only_integer }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0.0) }
    it { is_expected.to validate_presence_of(:total_price) }
    it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0.0) }
    it { is_expected.to validate_uniqueness_of(:item_id).scoped_to(:order_id) }

  end

  context 'check with item\'s stock' do

    define_method(:check_order_item_quantity) do
      expect(order_item.valid?).to be_falsy
      expect(order_item.errors[:quantity]).not_to be_empty
    end

    context 'when create' do
      include_context 'create_a_valid_order' do
        let(:order_item) { FactoryGirl.build(:order_item, quantity: 15) }
      end

      it 'order item\'s quantity can not greater than quantity in stock' do
        check_order_item_quantity
      end
    end

    context 'when update' do
      include_context 'create_a_valid_order'

      before(:each) do
        order_item.valid?
        order.update_attributes(status: :new)
      end

      it 'order item\'s quantity can not greater than quantity in stock' do
        order_item.quantity = 15
        check_order_item_quantity
      end
    end

  end

  context 'check unit price and total price' do
    include_context 'create_a_valid_order'

    before(:each) do
      order_item.valid?
      order.update_attributes(status: :new)
      order_item.reload
    end

    it 'should have valid unit price and quantity price' do
      expect(order_item.unit_price).to eq item.price
      expect(order_item.total_price).to eq item.price * order_item.quantity
    end
  end

end
