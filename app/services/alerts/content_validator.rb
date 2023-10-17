module Alerts
  class ContentValidator
    def initializer(content)
      @content = content
    end

    attr_reader :content

    def validate
      is_valid = is_date_format_valid? &&
                  is_alert_type_valid? &&
                  are_coordinates_valid?


      { is_valid: is_valid }
    end

    private

    def are_coordinates_valid?
      content['LAT'].match?(/^\d*\.\d*$/) &&
        content['LON'].match?(/^\d*\.\d*$/)
    end

    def is_date_format_valid?
      begin
        DateTime.parse(content['DT'])
      rescue Date::Error => e
        false
      end
    end

    def is_alert_type_valid?
      Alert::ALERT_TYPES.keys.include?(content['T'].downcase.to_sym)
    end
  end
end