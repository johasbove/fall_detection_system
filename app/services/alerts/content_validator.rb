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
      Dates::Validator.new(content[:DT]).is_valid?
    end

    def is_alert_type_valid?
      Alert.validate_type(content[:T])
    end
  end
end