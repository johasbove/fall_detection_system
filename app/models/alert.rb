class Alert < ApplicationRecord
  ALERT_TYPES = {
    bpm: 0, # abnormal heart rate bpm
    temp: 1, # abnormal temperature
    fall: 2 # fall
  }
  belongs_to :device

  enum :alert_type, ALERT_TYPES

  validates :latitude, :longitud, :device_id, presence: true
end
