FactoryBot.define do
  factory :caregiver do
    phone { "+36612345678" }
    health_center { HealthCenter.first || create(:health_center) }
  end
end
