# frozen_string_literal: true

require 'sidekiq/testing'
RSpec.describe MetadataListener::Job do
  let(:path) { MetadataListener.s3_client.upload_file(file: fixture_path.join('1.pdf')) }

  before do
    allow(MetadataListener::Report::Virus).to receive(:call)
    allow(MetadataListener::Report::Metadata).to receive(:call)
    Sidekiq::Testing.inline!
  end

  after do
    Sidekiq::Testing.fake!
  end

  it 'responds to perform_async' do
    expect(described_class).to respond_to(:perform_async)
  end

  it 'includes Sidekiq::Job' do
    expect(described_class.included_modules).to include(Sidekiq::Job)
  end

  it 'enqueues jobs on the metadata queue' do
    Sidekiq::Testing.fake! do
      described_class.clear
      described_class.perform_async('path' => path)

      expect(described_class.jobs.last['queue']).to eq('metadata')
    end
  end

  context 'without requesting any specific services' do
    it 'calls the virus report by default' do
      described_class.perform_async('path' => path)
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
      described_class.perform_async('path' => path, 'services' => ['metadata'])
      expect(MetadataListener::Report::Virus).not_to have_received(:call)
      expect(MetadataListener::Report::Metadata).to have_received(:call).with(
        path: a_kind_of(String),
        endpoint: nil,
        api_token: nil
      )
    end

    context 'when including a custom endpoint and api token' do
      let(:endpoint) { 'https://example.com/endpoint' }
      let(:api_token) { 'abc123' }

      it 'calls the metadata report with the custom endpoint and api token' do
        described_class.perform_async('path' => path, 'services' => ['metadata'], 'endpoint' => endpoint,
                                      'api_token' => api_token)
        expect(MetadataListener::Report::Virus).not_to have_received(:call)
        expect(MetadataListener::Report::Metadata).to have_received(:call).with(
          path: a_kind_of(String),
          endpoint:,
          api_token:
        )
      end
    end
  end
end
