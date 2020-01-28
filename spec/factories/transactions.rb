FactoryBot.define do
  factory :transaction do
    credit_card_number { "MyString" }
    credit_card_expiration_date { "2020-01-28 11:54:01" }
    result { "MyString" }
  end
end
