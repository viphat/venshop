require 'rails_helper'

RSpec.describe Item, type: :model do

  context 'check by shoulda matchers' do
    subject(:item) { FactoryGirl.build(:item) }

    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:inventory_items).dependent(:destroy) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to delegate_method(:category_name).to(:category) }

    it { is_expected.to validate_presence_of(:item_name) }
    it { is_expected.to validate_length_of(:item_name)
                        .is_at_most(255) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to have_attached_file(:item_image) }
    it { is_expected.to validate_attachment_content_type(:item_image)
          .allowing('image/png', 'image/jpeg', 'image/bmp', 'image/gif')
          .rejecting('text/plain', 'text/xml') }
  end

  context '#import_item' do
    let(:item) { FactoryGirl.create(:item) }

    it 'should raise error when import quantity less than or equal to 0' do
      expect(item.quantity).to eq 0
      expect{ item.import_item(0) }.to raise_error('Import quantity must greater than 0.')
      expect{ item.import_item(-5) }.to raise_error('Import quantity must greater than 0.')
    end

    it 'should import successfully when import quantity greater than 0' do
      expect(item.quantity).to eq 0
      expect{ item.import_item(5) }.to change { InventoryItem.imported.count }.by(1)
      expect(item.quantity).to eq 5
      expect{ item.import_item(10) }.to change { InventoryItem.imported.count }.by(1)
      expect(item.quantity).to eq 15
    end

  end

end
