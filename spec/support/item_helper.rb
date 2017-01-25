module ItemHelper

  def import_item(item:, quantity:)
    FactoryGirl.create(:inventory_item, item: item, quantity: quantity)
  end

  RSpec.shared_context 'preparing_items' do
    let(:number_of_creating_items) { 5 }
    let(:quantity_of_each_item) { 5 }

    before(:each) do
      # Create Items
      FactoryGirl.create_list(:item, number_of_creating_items)
      # Import
      Item.all.each do |item|
        import_item(item: item, quantity: quantity_of_each_item)
      end
    end
  end

end
