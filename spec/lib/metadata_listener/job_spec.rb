# frozen_string_literal: true

RSpec.describe MetadataListener::Job do
  let(:path) { upload_file(file: fixture_path.join('1.pdf')) }

  before do
    allow(MetadataListener::VirusReportingService).to receive(:call)
    allow(MetadataListener::MetadataReportingService).to receive(:call)
  end

  it { is_expected.to be_an(ActiveJob::Base) }

  context 'without requesting any specific services' do
    it 'calls the VirusReportingService by default' do
      described_class.perform_now(path: path)
      expect(MetadataListener::MetadataReportingService).not_to have_received(:call)
      expect(MetadataListener::VirusReportingService).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end
  end

  context 'when requesting a metadata report' do
    it 'calls the Metadata report' do
      described_class.perform_now(path: path, services: [:metadata])
      expect(MetadataListener::VirusReportingService).not_to have_received(:call)
      expect(MetadataListener::MetadataReportingService).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end
  end
end
