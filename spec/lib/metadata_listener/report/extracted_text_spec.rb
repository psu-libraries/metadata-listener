# frozen_string_literal: true

RSpec.describe MetadataListener::Report::ExtractedText do
  let(:mock_tika) { instance_spy(MetadataListener::Service::Tika) }
  let(:mock_logger) { instance_spy('Logger') }
  let(:extracted_text) { 'extracted text' }

  before do
    allow(MetadataListener::Service::Tika).to receive(:new).and_return(mock_tika)
    allow(mock_tika).to receive(:text).and_return(extracted_text)
    allow(MetadataListener).to receive(:logger).and_return(mock_logger)
  end

  describe '#send', :vcr do
    context 'when everything works' do
      it 'sends the results to an endpoint' do
        described_class.call(
          path: 'file_path',
          endpoint: 'https://scholarsphere-4.test/api/v1/files/1',
          api_token: 'db9c21583ea98d16e42a73d9f78897c1ffc1dffcae781eb17f841cf421bd22b7a1a1228226437c5fdf6b6c9a8f537b17'
        )
        expect(mock_logger).not_to have_received(:warn)
      end
    end

    context 'when unable to report results' do
      it 'logs the response from the endpoint' do
        described_class.call(
          path: 'file_path',
          endpoint: 'https://scholarsphere-4.test/api/v1/files/1'
        )
        expect(mock_logger).to have_received(:warn).with(/^Text extraction failed/)
      end
    end

    context 'when the file has no text' do
      let(:extracted_text) { '' }

      it 'logs the response from the endpoint' do
        described_class.call(
          path: 'file_path',
          endpoint: 'https://scholarsphere-4.test/api/v1/files/1'
        )
        expect(mock_logger).to have_received(:info).with('No text found in file')
      end
    end
  end
end
