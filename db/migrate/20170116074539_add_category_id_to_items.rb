class AddCategoryIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :category, foreign_key: true, index: true
  end
end
