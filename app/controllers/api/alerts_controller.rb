class Api::AlertsController < ApplicationController
  def create
    alert = Alerts::IncomingAlertBuilder.new(alert_params.to_h).build_alert

    if alert[:error].nil? && alert.save
      render json: { success: true, alert: alert }
    elsif alert[:error]
      render json: { success: false, error: alert[:error] }, status: 400
    else
      render json: { success: false }, status: 500
    end
  end

  private

  def alert_params
    params.permit(
      :status,
      :api_version,
      :sim_sid,
      :content
    )
  end
end