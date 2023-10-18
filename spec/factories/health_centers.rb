FactoryBot.define do
  factory :health_center do
    name { Faker::Superhero.unique.name }
    reference_code { Faker::Company.unique.duns_number }
  end
end
