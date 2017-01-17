class AddUserIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :user, foreign_key: true, index: true
  end
end
