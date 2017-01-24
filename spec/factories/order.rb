FactoryGirl.define do

  factory :order do
    status :in_progress
    association :user, factory: :user
    ordered_at nil
    delivered_at nil
    subtotal_price 0.0
    total_price 0.0
  end

end
