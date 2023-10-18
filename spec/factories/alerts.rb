FactoryBot.define do
  factory :alert do
    received_at { Time.current }
    received_value { "200" }
    alert_type { 1 }
    latitude { 1.5 }
    longitud { 1.5 }
    device { create(:device) }
  end
end
