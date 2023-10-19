class Api::AlertsController < ApplicationController
  def create
    alert = Alerts::IncomingAlertBuilder.new(alert_params.to_h).build_alert

    if alert[:error].nil? && alert.save
      alert.notify_caregiver

      render json: {
        success: true,
        alert: alert.as_json(
          except: [:id, :created_at, :updated_at, :device_id],
          include: { device: { only: :sim_sid } }
        )
      }
    elsif alert[:error]
      render json: { success: false, error: alert[:error] }, status: 400
    else
      render json: { success: false }, status: 500
    end
  end

  def index
    filter_result = Alerts::Filter.new(search_params.to_h).call

    if filter_result[:error].nil?
      alerts = filter_result[:alerts].page(page).per(per_page)

      render json: {
        success: true,
        alerts: alerts.as_json(
          except: [:id, :created_at, :updated_at, :device_id],
          include: { device: { only: :sim_sid } }
        )
      }
    else
      render json: { success: false, error: filter_result[:error] }, status: 400
    end
  end

  private

  def page
    params[:page].present? ? params[:page].to_i : 1
  end

  def per_page
    params[:per_page].present? ? params[:per_page].to_i : 25
  end

  def search_params
    params.permit(
      :at_dt,
      :type_key
    )
  end

  def alert_params
    params.permit(
      :status,
      :api_version,
      :sim_sid,
      :content
    )
  end
end