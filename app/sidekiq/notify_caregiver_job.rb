class NotifyCaregiverJob < ActiveJob::Base
  def perform(alert)
    content = Messages::ContentBuilder.new(alert).call
    health_center = alert.patient.health_center
    caregiver = nil
    message = nil

    Message.transaction do
      begin
        caregiver = Messages::CaregiverSelector.new(health_center).call
        message = Message.create!(alert: alert, status: 'sent', caregiver: caregiver)
      rescue ActiveRecord::ActiveRecordError
        raise Message.new("MessageCreation"), "Error creating caregiver messages"
      end
    end

    response = sms_external_service.call(caregiver.phone, content) if caregiver.present?
    success = response[:body][:success]
    raise Messages::ExternalApiError.new("SmsExternalApi"), "Error delivering caregiver messages" unless success

    message.received! if success
    { success: success }
  end

  private

  def sms_external_service
    Message.sms_external_service
  end
end
