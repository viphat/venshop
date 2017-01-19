class AddAddressToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :address, :string, limit: 255
  end
end
