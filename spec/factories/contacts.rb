FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    mobile_phone { Faker::PhoneNumber.cell_phone }
    position { Faker::Job.title }
  end
end
