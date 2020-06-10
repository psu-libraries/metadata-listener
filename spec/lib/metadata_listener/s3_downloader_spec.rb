# frozen_string_literal: true

RSpec.describe MetadataListener::S3Downloader do
  describe '#initialize' do
    before { described_class.new }

    it 'updates the AWS config' do
      skip 'Minio instance required for testing'
      expect(Aws.config.keys).to include(:access_key_id)
    end
  end
end
