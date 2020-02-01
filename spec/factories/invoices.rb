FactoryBot.define do
  factory :invoice do
    status { 1 }
    created_at { Faker::Time.backward(days: 30, period: :morning, format: :short) }
    updated_at { Faker::Time.backward(days: 2, period: :morning, format: :short) }
  end
end
