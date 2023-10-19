require 'rails_helper'

RSpec.describe Alerts::Filter do
  let!(:received_at_str) { '2015-07-30T20:00:00Z' }
  let!(:received_at) { DateTime.parse('2015-07-30T20:00:00Z') }
  let!(:alert_1) { create(:alert, received_at: received_at + 2.seconds) }
  let!(:alert_2) { create(:alert, received_at: received_at - 2.seconds, alert_type: 'fall') }
  let!(:alert_3) { create(:alert, received_at: received_at - 2.days) }
  let!(:filter_hash) { {
    at_dt: received_at_str,
    type_key: 'temp'
  } }

  subject { described_class.new(filter_hash).call }

  context 'when receiving invalid received_at as param' do
    it 'returns an error response and do not perform filter' do
      filter_hash[:at_dt] = 'HEY'

      response = subject

      expect(response[:error]).to be_present
      expect(response[:error]).to include('invalid params.')
      expect(response[:alerts].count).to eq(Alert.count)
    end
  end

  context 'when receiving invalid alert_type as param' do
    it 'returns an error response and do not perform filter' do
      filter_hash[:type_key] = 'HEY'

      response = subject

      expect(response[:error]).to be_present
      expect(response[:error]).to include('invalid params.')
      expect(response[:alerts].count).to eq(Alert.count)
    end
  end

  context 'when receiving empty values as params' do
    it 'does not return error and performs only the received filters' do
      filter_hash[:at_dt] = ''

      response = subject

      expect(response[:error]).not_to be_present
      expect(response[:alerts].count).to eq(2)
    end

    it 'does not return error and performs only the received filters' do
      filter_hash[:type_key] = ''

      response = subject

      expect(response[:error]).not_to be_present
      expect(response[:alerts].count).to eq(2)
    end
  end

  context 'when receiving valid alert_type as param' do
    it 'filters the results' do
      filter_hash[:type_key] = 'temp'

      response = subject

      expect(response[:error]).not_to be_present
      expect(response[:alerts].count).to eq(1)
      expect(response[:alerts][0].id).to eq(alert_1.id)
    end

    it 'filters the results' do
      filter_hash[:at_dt] = (received_at - 2.days).to_s

      response = subject

      expect(response[:error]).not_to be_present
      expect(response[:alerts].count).to eq(1)
      expect(response[:alerts][0].id).to eq(alert_3.id)
    end
  end
end