FactoryGirl.define do

  factory :item do
    item_name FFaker::Book.title
    association :category, factory: :category 
    price 10.0
  end

end
