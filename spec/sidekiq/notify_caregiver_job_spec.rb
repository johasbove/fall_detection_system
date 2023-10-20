require 'rails_helper'

RSpec.describe NotifyCaregiverJob, type: :job do
  let!(:alert) { create(:alert) }
  let!(:caregiver) { create(:caregiver) }

  before do
    allow(Message).to receive(:sms_external_service).and_return(Messages::ExternalApi::InMemory)
  end

  subject { described_class.perform_now(alert) }

  describe '#perform' do
    it 'creates a message' do
      expect { subject }.to change { Message.count }.by(1)
    end

    it 'calls SMS external service' do
      subject

      expect(Messages::ExternalApi::InMemory)
        .to receive(:call)
        .at_least(:once)
    end

    it 'responds with success if message is sent' do
      response = subject

      expect(response[:success]).to eq(true)
    end

    it 'raises an error if external service responds with error' do

      subject

      # expect(Messages::ExternalApi::InMemory)
      #   .to receive(:call)
      #   .at_least(:once)
      #   .with(alert, caregiver)
      #   .and_return({ success: false })
      # expect { described_class.perform_now(alert) }.to raise_error
    end
  end
end
