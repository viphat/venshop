class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.timestamps
      t.string :category_name, null: false, unique: true, limit: 255
    end
  end
end
