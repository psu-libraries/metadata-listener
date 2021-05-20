# frozen_string_literal: true

RSpec.describe MetadataListener::Report::Virus do
  let(:mock_logger) { instance_spy('Logger') }

  before do
    allow(MetadataListener::Service::Clamav).to receive(:call).and_return(false)
    allow(MetadataListener).to receive(:logger).and_return(mock_logger)
  end

  context 'when the file is clean' do
    it 'logs a success message' do
      described_class.call(path: 'file_path')
      expect(mock_logger).to have_received(:info).with('No virus found for file_path')
    end
  end

  context 'when the file has a virus' do
    before { allow(MetadataListener::Service::Clamav).to receive(:call).and_return(true) }

    it 'logs failure message' do
      described_class.call(path: 'file_path')
      expect(mock_logger).to have_received(:fatal).with('!!! Virus FOUND for file_path')
    end
  end

  context 'when reporting results', :vcr do
    it 'sends the results to an endpoint' do
      described_class.call(
        path: 'file_path',
        endpoint: 'https://scholarsphere-4.test/api/v1/metadata/1',
        api_token: 'xxxxxx'
      )
      expect(mock_logger).not_to have_received(:warn)
    end
  end

  context 'when unable to report results', :vcr do
    it 'logs the response from the endpoint' do
      described_class.call(
        path: 'file_path',
        endpoint: 'https://scholarsphere-4.test/api/v1/metadata/1'
      )
      expect(mock_logger).to have_received(:warn).with(/^Report failed/)
    end
  end
end
