FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    is_active { true }
  end
end
