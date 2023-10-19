module Dates
  class Validator
    def initialize(date_string)
      @date_string = date_string
    end

    attr_reader :date_string

    def is_valid?
      begin
        date_string.present? &&
          DateTime.parse(date_string).class.eql?(DateTime)
      rescue Date::Error => e
        false
      end
    end
  end
end
