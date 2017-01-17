class Category < ApplicationRecord
  has_many :items, dependent: :destroy
  validates :category_name, presence: true, length: { maximum: 255 }
end
