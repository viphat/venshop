class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :item
  has_one :inventory_item, dependent: :destroy

  delegate :user, to: :order
  delegate :item_name, to: :item

  validates :order, presence: true
  validates :item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates_uniqueness_of :item_id, scope: :order_id

  validate :check_with_inventory?, on: [:create, :update]

  before_validation :set_price, on: [:create, :update]

  after_save :force_updating_order_price
  after_save :update_inventory_item

  private

  def update_inventory_item
    inventory_item = InventoryItem.find_by(order_item: id)
    return if inventory_item.nil?
    inventory_item.save
  end

  def set_price
    self.unit_price = item.price if unit_price.nil?
    self.total_price = unit_price * quantity
  end

  def check_with_inventory?
    return if item.nil?
    errors.add(:quantity, 'must less than or equal to inventory quantity') if !quantity.nil? && quantity > item.quantity
  end

  def force_updating_order_price
    order.save
  end
end
