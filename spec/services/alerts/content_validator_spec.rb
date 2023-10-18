require 'rails_helper'

RSpec.describe Alerts::ContentValidator do
  let!(:content_hash) { {
    'initial_word': 'ALERT',
    'DT': '2015-07-30T20:00:00Z',
    'T': 'BPM',
    'VAL': '200',
    'LAT': '52.1544408',
    'LON': '4.2934847'
  } }

  subject { described_class.new(content_hash).validate }

  # "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"

  context 'when receiving valid content' do
    it 'returns validity as true' do
      response = subject

      expect(response[:is_valid]).to eq(true)
    end
  end

  context 'when receiving invalid initial word' do
    it 'returns an error response' do
      content_hash['initial_word'] = 'HEY'

      response = subject


      expect(response[:is_valid]).to eq(false)
    end

    it 'returns an error response' do
      content_hash['initial_word'] = ''

      response = subject

      expect(response[:is_valid]).to eq(false)
    end
  end

  context 'when receiving invalid datetime' do
    it 'returns an error response' do
      content_hash['DT'] = 'HEY'

      response = subject

      expect(response[:is_valid]).to eq(false)
    end

    it 'returns an error response' do
      content_hash['DT'] = ''

      response = subject

      expect(response[:is_valid]).to eq(false)
    end
  end

  context 'when receiving an invalid alert type' do
    it 'returns an error response' do
      content_hash['T'] = 'XYZ'

      response = subject

      expect(response[:is_valid]).to eq(false)
    end

    it 'returns an error response' do
      content_hash['T'] = ''

      response = subject

      expect(response[:is_valid]).to eq(false)
    end
  end

  context 'when receiving invalid latitude' do
    it 'returns an error response' do
      content_hash['LAT'] = 'HEY'

      response = subject

      expect(response[:is_valid]).to eq(false)
    end

    it 'returns an error response' do
      content_hash['LAT'] = ''

      response = subject

      expect(response[:is_valid]).to eq(false)
    end
  end

  context 'when receiving invalid longitud' do
    it 'returns an error response' do
      content_hash['LON'] = 'HEY'

      response = subject

      expect(response[:is_valid]).to eq(false)
    end

    it 'returns an error response' do
      content_hash['LON'] = ''

      response = subject

      expect(response[:is_valid]).to eq(false)
    end
  end
end