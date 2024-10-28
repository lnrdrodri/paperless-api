FactoryBot.define do
  factory :role do
    slug { Faker::Lorem.word }
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    is_active { true }
  end
end
