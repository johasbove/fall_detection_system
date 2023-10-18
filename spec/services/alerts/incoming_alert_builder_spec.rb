require 'rails_helper'

RSpec.describe Alerts::IncomingAlertBuilder do
  let!(:device) { create(:device) }
  let!(:alert_params) { {
    "status": "received",
    "api_version": "v1",
    "sim_sid": Device.last.sim_sid,
    "content": "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847",
    "direction": "from_sim"
  } }

  subject { described_class.new(alert_params).build_alert }

  context 'when receiving valid alert params' do
    it 'does not return an error message' do
      response = subject

      expect(response[:error]).not_to be_present
    end
  end

  context 'when receiving empty sim_sid' do
    it 'returns an error response' do
      alert_params['sim_sid'] = ''

      response = subject

      expect(response[:error]).to include('Missing SIM sid.')
    end
  end

  context 'when receiving invalid sim_sid' do
    it 'returns an error response' do
      alert_params['sim_sid'] = 'ANOTHER_SIM_ID'

      response = subject

      expect(response[:error]).to include('Device does not exists.')
    end
  end

  context 'when receiving empty content' do
    it 'returns an error response' do
      alert_params['content'] = ''

      response = subject

      expect(response[:error]).to include('Missing content data.')
    end
  end

  # All cases of invalid content are tested in Alerts::ContentValidator
  context 'when receiving invalid content' do
    it 'returns an error response' do
      alert_params['content'] = 'PEPITO DT T=BPM VAL=200 LAT=52.1544408 LON=4.2934847'

      response = subject

      expect(response[:error]).to include('Invalid content format.')
    end
  end
end