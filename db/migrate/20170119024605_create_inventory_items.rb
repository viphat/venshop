class CreateInventoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_items do |t|
      t.timestamps
      t.references :item, foreign_key: true, null: false, index: true
      t.references :order_item, foreign_key: true, index: true, unique: true
      t.string :status, null: false
      t.integer :quantity, null: false
    end
  end
end
