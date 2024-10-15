FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    state_id { create(:state).id }
  end
end
