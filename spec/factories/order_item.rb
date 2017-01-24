FactoryGirl.define do

  factory :order_item do
    association :order, factory: :order
    association :item, factory: :item
    quantity 1
    unit_price 0.0
    total_price 0.0
  end

end
