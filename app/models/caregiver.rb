class Caregiver < ApplicationRecord
  belongs_to :health_center
  has_many :messages

  # TODO Add phone validations
end
