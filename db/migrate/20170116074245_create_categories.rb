class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    drop_table 'categories' if ActiveRecord::Base.connection.table_exists? 'categories'
    create_table :categories do |t|
      t.timestamps
      t.string :category_name, null: false, unique: true, limit: 255
    end
  end
end
