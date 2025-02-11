# frozen_string_literal: true

RSpec.describe MetadataListener::Job do
  let(:path) { MetadataListener.s3_client.upload_file(file: fixture_path.join('1.pdf')) }

  before do
    allow(MetadataListener::Report::Virus).to receive(:call)
    allow(MetadataListener::Report::Metadata).to receive(:call)
  end

  it { is_expected.to be_an(ActiveJob::Base) }

  context 'without requesting any specific services' do
    it 'calls the virus report by default' do
      described_class.perform_now(path:)
      expect(MetadataListener::Report::Metadata).not_to have_received(:call)
      expect(MetadataListener::Report::Virus).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end
  end

  context 'when requesting a metadata report' do
    it 'calls the metadata report' do
      described_class.perform_now(path:, services: [:metadata])
      expect(MetadataListener::Report::Virus).not_to have_received(:call)
      expect(MetadataListener::Report::Metadata).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end
  end

  context 'when the job reaches timeout' do
    before do
      allow(MetadataListener::Report::Virus).to receive(:call).and_return(sleep(10))
    end

    it 'raises Timeout::Error' do
      stup_const('MetadataListener::Job::TIMEOUT', 3)
      expect { described_class.perform_now(path:) }.to raise_error(Timeout::Error)
    end
  end
end
