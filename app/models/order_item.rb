class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :item
  delegate :user, to: :order

  validates :order, presence: true
  validates :item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0.0, only_integer: true }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  before_create :set_unit_price
  before_validation :set_total_price, on: [:create, :update]

  private

    def unit_price
      self.unit_price = item.price
    end

    def set_total_price
      self.total_price = unit_price * quantity
    end

end
