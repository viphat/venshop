FactoryGirl.define do

  factory :category do
    category_name { FFaker::Name.name }
  end

end
