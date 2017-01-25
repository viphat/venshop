class Order < ApplicationRecord
  extend Enumerize

  SHIPPING_COST=3.0
  # We will provide free shipping if the order's total price is greater or equal to
  FREE_SHIPPING_PRICE=100.0

  has_many :order_items, dependent: :destroy, inverse_of: :order
  has_many :items, through: :order_items
  has_many :inventory_items, through: :order_items
  belongs_to :user

  accepts_nested_attributes_for :order_items

  validates :user, presence: true
  validates :ordered_at, absence: true, if: 'status.in_progress?'
  validates :ordered_at, presence: true, unless: 'status.in_progress?'
  validates :delivered_at, absence: true, unless: 'status.done? || status.refunded?'
  validates :delivered_at, presence: true, if: 'status.done? || status.refunded?'
  validates :subtotal_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  validate :has_at_least_one_order_item?, unless: 'status.in?(["in_progress", "cancel", "refunded"])', on: [:create, :update]
  validate :check_subtotal_with_total?, on: [:create, :update]

  before_validation :set_ordered_at
  before_validation :set_delivered_at

  before_save :set_subtotal_price
  before_save :set_total_price

  after_save :create_sold_inventory_items, if: 'status.in?(["new", "preparing", "shipping", "done"])'
  after_save :destroy_sold_inventory_items, if: 'status.in?(["in_progress", "cancel", "refunded"])'

  enumerize :status, in: [:in_progress, :new, :preparing, :shipping, :done, :cancel, :refunded],
            default: :in_progress, predicates: true, scope: true

  def create_or_update_order_item(order_item_params)
    # Update Quantity if this Item was added to Shopping Cart before
    if order_items.where(item_id: order_item_params[:item_id]).exists?
      order_item = order_items.find_by(item_id: order_item_params[:item_id])
      order_item.quantity += order_item_params[:quantity].to_i
      return order_item
    end
    order_items.new(order_item_params)
  end

  def checkout_order(address)
    return false unless self.status.in_progress?
    self.status = :new
    self.shipping_address = address
    if self.save
      # Use Sidekiq to send Email
      OrderMailer.delay.new_order(self)
      return true
    end
    false
  end

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
      self.subtotal_price = OrderItem.where(order_id: id).sum(:total_price)
    end

    # Order's total price after tax and shipping cost
    def set_total_price
      self.total_price = subtotal_price
      self.total_price += SHIPPING_COST if subtotal_price < FREE_SHIPPING_PRICE
    end

    def set_ordered_at
      return unless self.persisted?
      return self.ordered_at = nil if status.in_progress?
      return unless ordered_at.nil?
      self.ordered_at = Time.current
    end

    def set_delivered_at
      return unless self.persisted?
      return self.delivered_at = nil unless status.done? || status.refunded?
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
