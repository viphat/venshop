class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.timestamps
      t.references :user, foreign_key: true, index: true
      t.string :status, null: false
      t.float :subtotal_price, null: false, default: 0.0
      t.float :total_price, null: false, default: 0.0
      t.datetime :ordered_at
      t.datetime :delivered_at
    end
  end
end
