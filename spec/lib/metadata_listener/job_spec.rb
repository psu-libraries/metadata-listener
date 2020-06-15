# frozen_string_literal: true

RSpec.describe MetadataListener::Job do
  it { is_expected.to be_an(ActiveJob::Base) }

  context 'when the file does NOT have a virus' do
    let(:file_data) { upload_file(file: fixture_path.join('1.pdf')) }

    it 'downloads the file and checks for viruses' do
      expect(described_class.perform_now(file_data: file_data)).to be(false)
    end
  end

  context 'when file data is missing' do
    it 'raises an error' do
      expect {
        described_class.perform_now(missing_data: {})
      }.to raise_error(KeyError)
    end
  end

  context 'when file data is missing required keys' do
    it 'raises an error' do
      expect {
        described_class.perform_now(file_data: {})
      }.to raise_error(ArgumentError, 'file_data must have an id')
    end
  end
end
