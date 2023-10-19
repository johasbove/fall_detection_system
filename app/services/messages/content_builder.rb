module Messages
  class ContentBuilder
    def initialize(alert)
      @alert = alert
    end

    attr_reader :alert

    def call
      <<~TEXT
        -- Type: #{alert.alert_type.upcase}
        -- Date and time of incident: #{alert.received_at.strftime('%d-%m-%Y %H:%M')}
        -- Patient: #{alert.patient_name}
        -- Additional information: #{alert.patient_additional_information}
      TEXT
    end
  end
end
