module Alerts
  class ContentValidator
    INITIAL_WORD = 'ALERT'.freeze

    def initialize(content)
      @content = content.with_indifferent_access
    end

    attr_reader :content

    def validate
      is_valid = is_initial_word_valid? &&
                  is_date_format_valid? &&
                  is_alert_type_valid? &&
                  are_coordinates_valid?

      { is_valid: is_valid }
    end

    private

    def is_initial_word_valid?
      content[:initial_word].eql?(INITIAL_WORD)
    end

    def are_coordinates_valid?
      content[:LAT].present? &&
        content[:LON].present? &&
        content[:LAT].match?(/^\d*\.\d*$/) &&
        content[:LON].match?(/^\d*\.\d*$/)
    end

    def is_date_format_valid?
      begin
        content[:DT].present? &&
          DateTime.parse(content[:DT]).class.eql?(DateTime)
      rescue Date::Error => e
        false
      end
    end

    def is_alert_type_valid?
      content[:T].present? &&
        Alert::ALERT_TYPES.keys.include?(content[:T].downcase.to_sym)
    end
  end
end