class Alert < ApplicationRecord
  ALERT_TYPES = {
    bpm: 0, # abnormal heart rate bpm
    temp: 1, # abnormal temperature
    fall: 2 # fall
  }
  belongs_to :device

  has_one :message

  enum :alert_type, ALERT_TYPES

  validates :latitude, :longitud, :device_id, presence: true

  scope :by_received_at, -> (received_at) { where(received_at: ((received_at - 30.seconds)..(received_at + 30.seconds))) }
  scope :by_alert_type, -> (alert_type) { where(alert_type: alert_type) }

  def self.validate_type(type_str)
    type_str.present? &&
        Alert::ALERT_TYPES.keys.include?(type_str.downcase.to_sym)
  end

  def patient
    @patient ||= Alert.where(id: id).includes(device: :patient).take.device.patient
  end

  def patient_name
    "#{patient.first_name} #{patient.last_name}"
  end

  def patient_additional_information
    patient.additional_information
  end

  def notify_caregiver
    NotifyCaregiverJob.perform_async(self, caregiver)
  end
end
