FactoryBot.define do
  factory :address do
    reference_type { 'User' }
    reference_id { create(:user).id }
    street { Faker::Address.street_address }
    number { Faker::Address.building_number }
    neighborhood { Faker::Address.community }
    complement { Faker::Address.secondary_address }
    zip_code { Faker::Address.zip_code }

    city_id { create(:city).id }    
  end
end
