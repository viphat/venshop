class Category < ApplicationRecord
  ITEMS_LIMIT = 10

  has_many :items, dependent: :destroy
  validates :category_name, presence: true,
                            uniqueness: { case_sensitive: false },
                            length: { maximum: 255 }
end
