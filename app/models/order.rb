class Order < ApplicationRecord
  extend Enumerize

  SHIPPING_COST=3.0
  # We will provide free shipping if the order's total price is greater or equal to
  FREE_SHIPPING_PRICE=100.0

  belongs_to :user
  has_many :order_items, dependent: :destroy, inverse_of: :order
  has_many :items, through: :order_items
  has_many :inventory_items, through: :order_items

  accepts_nested_attributes_for :order_items

  validates :status, presence: true
  validates :user, presence: true
  validates :ordered_at, absence: true, if: 'status.in_progress?'
  validates :ordered_at, presence: true, unless: 'status.in_progress?'
  validates :delivered_at, absence: true, unless: 'status.done? || status.refunded?'
  validates :delivered_at, presence: true, if: 'status.done? || status.refunded?'
  validates :subtotal_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  validate :has_at_least_one_order_item?, on: [:create, :update]
  validate :check_subtotal_with_total?, on: [:create, :update]

  before_validation :set_ordered_at, on: [:create, :update]
  before_validation :set_delivered_at, on: [:create, :update]
  before_validation :set_subtotal_price, on: [:create, :update]
  before_validation :set_total_price, on: [:create, :update]

  after_save :create_sold_inventory_items, if: "status.in?(['new', 'preparing', 'shipping', 'done'])"
  after_save :destroy_sold_inventory_items, if: "status.in?(['in_progress', 'cancel', 'refunded'])"

  enumerize :status, in: [:in_progress, :new, :preparing, :shipping, :done, :cancel, :refunded],
            default: :in_progress, predicates: true, scope: true

  private

    def create_sold_inventory_items
      ActiveRecord::Base.transaction do
        order_items.each do |order_item|
          next unless order_item.inventory_item.nil?
          order_item.create_inventory_item!(status: :sold)
        end
      end
    end

    def destroy_sold_inventory_items
      inventory_items.sold.destroy_all
    end

    # Order's total price before tax and shipping cost
    def set_subtotal_price
      self.subtotal_price = order_items.sum(:total_price)
    end

    # Order's total price after tax and shipping cost
    def set_total_price
      self.total_price = subtotal_price
      self.total_price += SHIPPING_COST if subtotal_price < FREE_SHIPPING_PRICE
    end

    def set_ordered_at
      return if status.in_progress?
      return unless ordered_at.nil?
      self.ordered_at = Time.current
    end

    def set_delivered_at
      return unless status.done?
      return unless delivered_at.nil?
      self.delivered_at = Time.current
    end

    def has_at_least_one_order_item?
      self.errors.add(:base, 'must add at least one order item') if order_items.size.zero?
    end

    def check_subtotal_with_total?
      self.errors.add(:total_price, 'must greater than or equal to subtotal') if total_price < subtotal_price
    end

end
