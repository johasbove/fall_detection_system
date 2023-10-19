module Alerts
  class Filter
    def initialize(params)
      @params = params.with_indifferent_access
      @filter_params = {}.with_indifferent_access
      parse_params
    end

    attr_reader :params, :filter_params

    def call
      return { error: 'invalid params.', alerts: Alert.all } if !are_params_valid?

      alerts = Alert
      alerts = alerts.by_received_at(DateTime.parse(filter_params[:received_at])) if filter_params[:received_at].present?
      alerts = alerts.by_alert_type(filter_params[:alert_type]) if filter_params[:alert_type].present?

      { alerts: alerts }
    end

    private

    def are_params_valid?
      is_received_at_valid? &&
        is_alert_type_valid?
    end

    def is_received_at_valid?
      return true if filter_params[:received_at].nil?

      Dates::Validator.new(filter_params[:received_at]).is_valid?
    end

    def is_alert_type_valid?
      return true if filter_params[:alert_type].nil?

      Alert.validate_type(filter_params[:alert_type])
    end

    def parse_params
      @filter_params[:received_at] = params[:at_dt] if params[:at_dt].present?
      @filter_params[:alert_type] = params[:type_key] if params[:type_key].present?
    end
  end
end