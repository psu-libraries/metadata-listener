# frozen_string_literal: true

RSpec.describe MetadataListener::FitsService do
  subject(:service) { described_class.call(path) }

  let(:path) { fixture_path.join('1.pdf').to_s }

  context 'when successfull' do
    it { is_expected.to be_a(Hash) }
  end

  context 'with a pdf' do
    it 'extracts metadata from the file' do
      expect(service.dig('fits', 'identification', 'identity', 'mimetype')).to eq('application/pdf')
    end
  end

  context 'with a Word document' do
    let(:path) { fixture_path.join('1.docx').to_s }

    it 'extracts metadata from the file' do
      expect(service.dig('fits', 'identification', 'identity', 'mimetype')).to eq(
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      )
    end
  end

  context 'with a PowerPoint document' do
    let(:path) { fixture_path.join('1.pptx').to_s }

    it 'extracts metadata from the file' do
      expect(
        service.dig('fits', 'identification', 'identity').map { |identity| identity.dig('mimetype') }
      ).to include(
        'application/vnd.openxmlformats-officedocument.presentationml.presentation'
      )
    end
  end

  context 'with errors during the FITs call' do
    before { ENV['FITS_PATH'] = '/usr/share/fits/fits.broken' }

    after { ENV['FITS_PATH'] = '/usr/share/fits/fits.sh' }

    it 'raises an error' do
      expect { service }.to raise_error(StandardError)
    end
  end

  context 'when the path does not exist' do
    let(:path) { '/not/here' }

    it { is_expected.to be_empty }
  end
end
