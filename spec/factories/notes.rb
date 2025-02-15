FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    user_id { create(:user).id }
    reference_type { 'Contact' }
    reference_id { create(:contact).id }
  end
end
