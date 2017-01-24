class InventoryItem < ApplicationRecord
  extend Enumerize

  scope :imported, -> { with_status(:imported) }
  scope :sold, -> { with_status(:sold) }

  belongs_to :item
  belongs_to :order_item, optional: true # Rails 5 belongs_to is required by default

  validates :item, presence: true
  validates :order_item, absence: true, if: 'status.imported?'
  validates :order_item, presence: true, uniqueness: true, if: 'status.sold?'
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validate :check_with_order_item_quantity?, if: 'status.sold?'

  before_validation :set_quantity, if: 'status.sold?', on: [:create, :update]
  before_validation :set_item_id, if: 'status.sold?', on: [:create, :update]

  enumerize :status, in: [:imported, :sold], default: :imported, predicates: true, scope: true

  private

    def check_with_order_item_quantity?
      self.errors.add(:quantity, 'must equal order item\'s quantity') unless quantity == order_item.quantity
    end

    def set_quantity
      self.quantity = order_item.quantity
    end

    def set_item_id
      self.item_id = order_item.item_id
    end

end
