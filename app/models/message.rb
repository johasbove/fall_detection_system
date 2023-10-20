class Message < ApplicationRecord
  STATUS = {
    failed: 0,
    sent: 1,
    received: 2
  }

  belongs_to :alert
  belongs_to :caregiver

  enum :status, STATUS

  validates :alert_id, uniqueness: { conditions: -> { where.not(status: 'failed') } }

  def self.sms_external_service
    Messages::ExternalApi::HttpClient
  end
end
