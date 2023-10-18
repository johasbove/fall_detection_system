require 'rails_helper'

describe Api::AlertsController, type: :controller do
  let!(:device) { create(:device) }
  let!(:params) { {
    'status': 'received',
    'api_version': 'v1',
    'sim_sid': Device.last.sim_sid,
    'content': 'ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847',
    'direction': 'from_sim'
  } }

  describe 'POST api/alerts #create' do
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
end