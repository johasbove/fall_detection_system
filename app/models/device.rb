class Device < ApplicationRecord
  belongs_to :health_center
  belongs_to :patient
end
