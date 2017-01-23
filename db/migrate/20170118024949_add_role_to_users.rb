class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :string, null: false, default: 'user', limit: 25
  end
end
