FactoryGirl.define do
  factory :package do
    weight 22.0
  end

  factory :destination do
    street
    country
    city
    state
    zip
  end
end
