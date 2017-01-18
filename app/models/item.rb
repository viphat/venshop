require 'open-uri'

class Item < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }

  NEWEST_ITEMS_LIMIT=4

  belongs_to :category
  delegate :category_name, to: :category

  validates :item_name, presence: true, length: { minimum: 10, maximum: 255 }
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  has_attached_file :item_image, styles: { small: "51x32>", medium: "71x38>", large: "110x86>" }
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

  def set_item_image_from_url(url)
    self.item_image = open(url)
  end

end
