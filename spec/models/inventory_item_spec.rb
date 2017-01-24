require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  include OrderHelper
  include InventoryItemHelper

  context 'check by shoulda matchers' do
    include_context 'skip_inventory_item_callbacks'

    subject(:inventory_item) { FactoryGirl.build(:inventory_item) }

    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:order_item) }

    it { is_expected.to validate_presence_of(:item) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0).only_integer }
    it { is_expected.to enumerize(:status).in(:imported, :sold)
                        .with_default(:imported) }

  end

  context '.imported' do
    subject(:inventory_item) { FactoryGirl.build(:inventory_item) }
    include_context 'create_a_valid_order'

    it { is_expected.to validate_absence_of(:order_item) }

    it 'should include imported item' do
      expect(InventoryItem.imported).to include(imported_item)
    end

    it 'should exclude sold item' do
      expect(InventoryItem.imported).not_to include(sold_item)
    end

  end

  context '.sold' do
    include_context 'create_a_valid_order'

    context 'check with shoulda matchers' do
      include_context 'skip_inventory_item_callbacks'
      subject(:sold_item) { InventoryItem.new(status: :sold) }
      it { is_expected.to validate_presence_of(:order_item) }
    end

    it 'should exclude imported item' do
      expect(InventoryItem.sold).not_to include(imported_item)
    end

    it 'should include sold item' do
      expect(InventoryItem.sold).to include(sold_item)
    end

    context '#check_with_order_item' do
      let(:new_quantity) { 5 }
      let(:other_item) { FactoryGirl.create(:item) }
      let(:other_imported_item) { FactoryGirl.create(:inventory_item, item: other_item) }

      it 'quantity should equal with order_item\'s quantity' do
        expect(sold_item.valid?).to be_truthy
        order_item.quantity = new_quantity
        order_item.save
        expect(sold_item.reload.quantity).to eq new_quantity
      end

      it 'should update item_id if order_item\'s item_id has changed' do
        sold_item.valid?
        other_imported_item.valid?
        order_item.item_id = other_item.id
        order_item.save
        expect(sold_item.reload.item_id).to eq other_item.id
      end

    end

  end

end
