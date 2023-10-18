FactoryBot.define do
  factory :patient do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    additional_information { "How to access the patient, patient conditions etc..." }
    health_center { HealthCenter.first || create(:health_center) }
  end
end
