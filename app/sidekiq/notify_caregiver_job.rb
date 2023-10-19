class NotifyCaregiverJob
  include Sidekiq::Job

  def perform(alert)
    content = Messages::ContentBuilder.new(alert).call
    health_center = patient.health_center
    caregiver = nil

    Message.transaction do
      caregiver = Messages::CaregiverSelector.new(health_center).call
      message = Message.create!(alert: alert, status: 'sent', caregiver: caregiver)
    end

    # TODO: Error handling from the external api
    response = sms_external_service.call(caregiver.phone, content) if caregiver.present?
    message.received! if response[:success]
  end

  private

  def sms_external_service
    ENV.fetch('RAILS_ENV', :sms_external_service)
  end
end
