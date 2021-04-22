# frozen_string_literal: true

RSpec.describe MetadataListener::MetadataReportingService do
  let(:fits_data) { { fits: { identity: 'sample metadata' } } }
  let(:mock_logger) { instance_spy('Logger') }

  before do
    allow(MetadataListener::FitsService).to receive(:call).and_return(fits_data)
    allow(MetadataListener).to receive(:logger).and_return(mock_logger)
  end

  context 'when reporting results', :vcr do
    it 'sends the results to an endpoint' do
      described_class.call(
        path: 'file_path',
        endpoint: 'http://host.docker.internal:3000/api/v1/files/1',
        api_token: 'db9c21583ea98d16e42a73d9f78897c1ffc1dffcae781eb17f841cf421bd22b7a1a1228226437c5fdf6b6c9a8f537b17'
      )
      expect(mock_logger).not_to have_received(:warn)
    end
  end

  context 'when unable to report results', :vcr do
    it 'logs the response from the endpoint' do
      described_class.call(
        path: 'file_path',
        endpoint: 'http://host.docker.internal:3000/api/v1/files/2',
        api_token: 'db9c21583ea98d16e42a73d9f78897c1ffc1dffcae781eb17f841cf421bd22b7a1a1228226437c5fdf6b6c9a8f537b17'
      )
      expect(mock_logger).to have_received(:warn).with(/^Report failed/)
    end
  end
end
