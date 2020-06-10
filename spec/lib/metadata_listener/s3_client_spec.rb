# frozen_string_literal: true

RSpec.describe MetadataListener::S3Client do
  describe '#initialize' do
    context 'with a valid config' do
      it 'updates the AWS config' do
        described_class.new
        expect(Aws.config.keys).to include(:access_key_id)
      end
    end

    context 'with an invalid S3 configuration' do
      it 'raises an error' do
        bucket = ENV['AWS_BUCKET']
        ENV['AWS_BUCKET'] = nil

        expect {
          described_class.new
        }.to raise_error(ArgumentError, 'S3 configuration is missing required options')
        ENV['AWS_BUCKET'] = bucket
      end
    end
  end

  describe '#download_file' do
    let(:downloader) { described_class.new }

    context 'when the file is available in S3' do
      let(:sample_file) { fixture_path.join('1.pdf') }

      let(:file_key) { upload_file(sample_file) }

      it 'downloads the file to a temporary location' do
        new_file = downloader.download_file(file_key)
        expect(Digest::MD5.hexdigest(new_file.body.read)).to eq(Digest::MD5.hexdigest(sample_file.read))
      end
    end

    context 'when the file is not available in S3' do
      it 'raises an error' do
        expect {
          downloader.download_file('imnothere')
        }.to raise_error(Aws::S3::Errors::NoSuchKey)
      end
    end
  end
end
