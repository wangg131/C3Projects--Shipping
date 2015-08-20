FactoryGirl.define do
  factory :package do
    weight 22.0
  end

  factory :origin do
    street "123 St"
    country "US"
    city "Seattle"
    state "WA"
    zip "98109"
  end

  factory :destination do
    street "456 St"
    country "US"
    city "Burlington"
    state "WA"
    zip "98233"
  end
end
