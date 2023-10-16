class HealthCenter < ApplicationRecord
  has_many :caregivers
  has_many :patients
  has_many :devices
end
