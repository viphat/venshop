class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    drop_table 'users' if ActiveRecord::Base.connection.table_exists? 'users'
    create_table :users do |t|
      t.timestamps null: false

      ## Database authenticatable
      t.string :name,               null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.attachment :avatar
    end

    add_index :users, :email,                unique: true
  end
end
