FactoryGirl.define do

  factory :inventory_item do
    association :item, factory: :item
    status :imported
    quantity 10

    trait :exported_inventory_item do
      status :sold
      association :order_item, factory: :order_item
      quantity 1
    end
  end

end
