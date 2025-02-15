FactoryBot.define do
  factory :unit do
    name { Faker::Name.name }
    cnpj { Faker::Company.brazilian_company_number }
    success_percentage { Faker::Number.decimal(l_digits: 2) }
    royalts { Faker::Number.number(digits: 2) }
  end
end
