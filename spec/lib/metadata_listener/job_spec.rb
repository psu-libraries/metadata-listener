# frozen_string_literal: true

RSpec.describe MetadataListener::Job do
  it { is_expected.to be_an(ActiveJob::Base) }

  context 'when everything goes according to plan' do
    let(:path) { upload_file(file: fixture_path.join('1.pdf')) }

    it 'downloads the file and call the VirusReportingService' do
      allow(MetadataListener::VirusReportingService).to receive(:call)
      described_class.perform_now(path: path)
      expect(MetadataListener::VirusReportingService).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end
  end
end
