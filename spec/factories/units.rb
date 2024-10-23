FactoryBot.define do
  factory :unit do
    name { Faker::Name.name }
    cnpj { Faker::Company.brazilian_company_number }

  end
end
