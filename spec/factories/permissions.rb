FactoryBot.define do
  factory :permission do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    action { Faker::Lorem.word }
  end
end
