FactoryGirl.define do

  factory :inventory_item do
    association :item, factory: :item
    status :imported
    quantity 10
    order_item nil
  end

end
