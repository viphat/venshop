require 'open-uri'

class Item < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }

  NEWEST_ITEMS_LIMIT=4
  ITEMS_ON_ADMIN_PAGE=10

  attr_accessor :import_quantity

  has_many :order_items, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  belongs_to :category
  delegate :category_name, to: :category

  validates :item_name, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  has_attached_file :item_image, styles: { small: '51x32>', medium: '71x38>', large: '110x86>' }
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

  def set_item_image_from_url(url)
    # Use to load image from Amazon
    self.item_image = open(url)
  end

  def sold_quantity
    inventory_items.sold.sum(:quantity)
  end

  def quantity
    inventory_items.imported.sum(:quantity) - sold_quantity
  end

  def import_item(quantity)
    raise ArgumentError.new('Import quantity must greater than 0.') and return if quantity <= 0
    self.inventory_items.imported.create(quantity: quantity)
  end

end
