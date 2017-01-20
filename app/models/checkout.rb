class Checkout
  include ActiveModel::Model
  include ActiveModel::Conversion

  attr_accessor :order, :user, :address
  delegate :name, to: :user
  delegate :order_items, to: :order

  def persisted?
    false
  end
end
