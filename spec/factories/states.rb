FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    iso { Faker::Address.state_abbr }
    country_id { create(:country).id }
  end
end
