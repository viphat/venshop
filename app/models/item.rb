require 'open-uri'

class Item < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }

  NEWEST_ITEMS_LIMIT=4
  ITEMS_ON_ADMIN_PAGE=10
  SEARCH_ITEMS_LIMIT=10

  attr_accessor :import_quantity

  has_many :order_items, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  belongs_to :category
  delegate :category_name, to: :category

  validates :item_name, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  after_save :solr_update_item, only: [:update]
  after_create :solr_push_item
  after_destroy :solr_destroy_item

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

  private

    def solr_update_item
      add_attributes = { allowDups: false, commitWithin: 10 }
      xml = $solr.xml.add(searchable, add_attributes)
      $solr.update(data: xml)
    end

    def solr_push_item
      $solr.add(searchable)
    end

    def solr_destroy_item
      $solr.delete_by_id(self.id)
    end

    def searchable
      {
        id: id,
        item_name: item_name,
        price: price
      }
    end

end
