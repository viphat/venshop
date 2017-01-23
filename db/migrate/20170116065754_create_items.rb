class CreateItems < ActiveRecord::Migration[5.0]
  def change
    drop_table 'items' if ActiveRecord::Base.connection.table_exists? 'items'
    create_table :items do |t|
      t.timestamps
      t.string :item_name, null: false, limit: 255
      t.float :price, null: false, default: 0.0
      t.attachment :item_image
    end
  end
end
