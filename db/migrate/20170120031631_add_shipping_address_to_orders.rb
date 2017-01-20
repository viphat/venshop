class AddShippingAddressToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :shipping_address, :string, limit: 255
  end
end
