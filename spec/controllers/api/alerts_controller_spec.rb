require 'rails_helper'

describe Api::AlertsController, type: :controller do
  describe 'POST api/alerts #create' do
    let!(:device) { create(:device) }
    let!(:params) { {
      'status': 'received',
      'api_version': 'v1',
      'sim_sid': Device.last.sim_sid,
      'content': 'ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847',
      'direction': 'from_sim'
    } }

    subject { post :create, params: params }

    context 'when receiving valid params' do
      it 'creates an alert with the information received' do
        expect { subject }.to change { Alert.count }.by(1)
        assert_response 200
      end
    end

    context 'when receiving invalid params' do
      it 'responds with status success false' do
        params['content'] = ''

        post :create, params: params

        json = JSON.parse(response.body)
        expect(json.dig('success')).to eq(false)
      end
    end
  end

  describe 'GET api/alerts #index' do
    let!(:received_at_str) { '2015-07-30T20:00:00Z' }
    let!(:received_at) { DateTime.parse('2015-07-30T20:00:00Z') }
    let!(:alert_1) { create(:alert, received_at: received_at + 2.seconds) }
    let!(:alert_2) { create(:alert, received_at: received_at - 2.seconds, alert_type: 'fall') }
    let!(:alert_3) { create(:alert, received_at: received_at - 2.days) }
    let!(:query_params) { {
      at_dt: received_at_str,
      type_key: 'temp'
    } }

    subject { get :index, params: query_params }

    context 'when receiving valid params' do
      it 'responds showing filtered results' do
        response = subject

        json = JSON.parse(response.body)
        expect(json.dig('success')).to eq(true)
        expect(json.dig('alerts').count).to eq(1)
        assert_response 200
      end
    end

    context 'when receiving invalid params' do
      it 'responds with status success false' do
        query_params[:type_key] = 'invalid'

        get :index, params: query_params

        json = JSON.parse(response.body)
        expect(json.dig('success')).to eq(false)
        assert_response 400
      end
    end
  end
end