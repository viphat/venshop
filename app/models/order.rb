class Order < ApplicationRecord
  extend Enumerize

  SHIPPING_COST=3.0
  # We will provide free shipping if the order's total price is greater or equal to
  FREE_SHIPPING_PRICE=100.0

  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  validates :user, presence: true
  validates :ordered_at, absence: true, if: "status.in_progress?"
  validates :ordered_at, presence: true, unless: "status.in_progress?"
  validates :delivered_at, absence: true, unless: "status.done? || status.refund?"
  validates :delivered_at, presence: true, if: "status.done? || status.refund?"
  validates :subtotal_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: subtotal_price }

  validate :has_at_least_one_order_item?, on: [:create, :update]

  before_validation :set_ordered_at, on: [:create, :update]
  before_validation :set_delivered_at, on: [:create, :update]
  before_validation :set_subtotal_price, on: [:create, :update]
  before_validation :set_total_price, on: [:create, :update]

  enumerize :status, in: [:in_progress, :new, :preparing, :shipping, :done, :cancel, :refund],
            default: :in_progress, predicates: true

  private

    # Order's total price before tax and shipping cost
    def set_subtotal_price
      self.subtotal_price = order_items.sum(:total_price)
    end

    # Order's total price after tax and shipping cost
    def set_total_price
      total = subtotal_price
      total += SHIPPING_COST if subtotal_price < FREE_SHIPPING_PRICE
      total
    end

    def set_ordered_at
      return if status.in_progress?
      return unless ordered_at.nil?
      self.ordered_at = Time.current
    end

    def set_delivered_at
      return if status.done?
      return unless delivered_at.nil?
      self.delivered_at = Time.current
    end

    def has_at_least_one_order_item?
      errors.add(:base, 'must add at least one order item') if order_items.size.zero?
    end

end
