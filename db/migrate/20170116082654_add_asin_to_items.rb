class AddAsinToItems < ActiveRecord::Migration[5.0]
  def change
    # use Amazon Standard Identification Number for reference later.
    add_column :items, :asin, :string, limit: 10
  end
end
