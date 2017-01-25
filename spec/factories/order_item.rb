FactoryGirl.define do

  factory :order_item do
    association :order, factory: :order
    association :item, factory: :item
    quantity 1
  end

end
