FactoryBot.define do
  factory :device do
    sim_sid { Faker::Lorem.unique.characters(number: 6, min_alpha: 4, min_numeric: 1) }
    health_center { HealthCenter.first || create(:health_center) }
    patient { create(:patient) }
  end
end
