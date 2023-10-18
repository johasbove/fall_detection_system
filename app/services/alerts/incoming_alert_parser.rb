module Alerts
  class IncomingAlertParser
    def initialize(alert_params)
      @alert_params = alert_params.with_indifferent_access
      @alert = Alert.new
    end

    attr_reader :alert_params, :alert

    def build_alert
      if is_valid?
        alert.assign_attributes(
          received_at: received_at,
          received_value: received_value,
          alert_type: alert_type,
          latitude: latitude,
          longitud: longitud,
          device: device
        )

        alert.save!
        alert
      else
        { error: 'invalid data'}
      end
    end

    private

    def is_valid?
      alert_params[:sim_sid].present? &&
        alert_params[:content].present? &&
        device_exists? &&
        is_content_valid?
    end

    def is_content_valid?
      response = ContentValidator.new(content_by_field).validate
      response[:is_valid]
    end

    def device_exists?
      !device.nil?
    end

    def device
      @device ||= Device.find_by(sim_sid: alert_params[:sim_sid])
    end

    def received_at
      DateTime.parse(content_by_field['DT'])
    end

    def alert_type
      content_by_field['T'].downcase
    end

    def received_value
      content_by_field['VAL']
    end

    def latitude
      content_by_field['LAT'].to_f
    end

    def longitud
      content_by_field['LON'].to_f
    end

    def content_by_field
      # content expected format
      # ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847

      return @content_by_field unless @content_by_field.nil?

      @content_by_field = {}
      raw_content = alert_params[:content]
      splitted_content = raw_content.split(' ')
      @content_by_field['initial_word'] = splitted_content[0]

      splitted_content[1..].each do |content_string|
        (key, val) = content_string.split('=')
        @content_by_field[key] = val
      end

      @content_by_field
    end
  end
end