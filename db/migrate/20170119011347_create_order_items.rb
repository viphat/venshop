class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.timestamps
      t.references :order, null: false, foreign_key: true, index: true
      t.references :item, null: false, foreign_key: true, index: true
      t.integer :quantity, null: false, default: 1
      t.float :unit_price, null: false
      t.float :total_price, null: false
    end
  end
end
