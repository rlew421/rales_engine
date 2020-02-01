FactoryBot.define do
  factory :merchant do
    name { Faker::TvShows::RickAndMorty.character }
    created_at { Faker::Time.backward(days: 30, period: :morning, format: :short) }
    updated_at { Faker::Time.backward(days: 7, period: :morning, format: :short) }
  end
end
