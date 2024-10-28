FactoryBot.define do
  factory :participant do
    name { Faker::Name.name }
    cnpj { Faker::Company.brazilian_company_number }
  end
end
