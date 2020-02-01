FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    unit_price { "" }
    created_at { Faker::Time.backward(days: 30, period: :morning, format: :short) }
    updated_at { Faker::Time.backward(days: 7, period: :morning, format: :short) }
  end
end
