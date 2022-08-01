# frozen_string_literal: true

RSpec.describe MetadataListener::Service::Tika do
  subject { described_class.new(path) }

  context 'with a pdf' do
    let(:path) { fixture_path.join('1.pdf').to_s }

    its(:text) { is_expected.to include('pdftestarticle') }
    its(:metadata) { is_expected.to include('Author' => 'Florian Grandel') }
  end

  context 'with a Word document' do
    let(:path) { fixture_path.join('1.docx').to_s }

    its(:text) { is_expected.to include('chambray') }
    its(:metadata) { is_expected.to include('Application-Name' => 'Microsoft Office Word') }
  end

  context 'with a PowerPoint document' do
    let(:path) { fixture_path.join('1.pptx').to_s }

    its(:text) { is_expected.to include('chambray') }
    its(:metadata) { is_expected.to include('Application-Name' => 'Microsoft Macintosh PowerPoint') }
  end

  context 'with a non-text document' do
    let(:path) { fixture_path.join('dot.png').to_s }

    its(:text) { is_expected.to eq('') }
    its(:metadata) { is_expected.to include('Content-Type' => 'image/png') }
  end

  context 'with a non UTF-8 document' do
    let(:mock_tika) { instance_spy(RubyTikaApp) }
    let(:mock_logger) { instance_spy(Logger) }

    before do
      allow(RubyTikaApp).to receive(:new).and_return(mock_tika)
      allow(MetadataListener).to receive(:logger).and_return(mock_logger)

      # Mock RubyTikaApp to return some funky binary ASCII-8BIT text data. We're not sure if Tika will ever _actually_
      # do this, but if it does, we don't want to send it along to Scholarpshere becuase it's assuming that all
      # extracted text coming from this app is UTF-8
      allow(mock_tika).to receive(:to_text).and_return("Hello \x93\xfa\x96\x7b".b)
    end

    it 'logs a message' do
      service = described_class.new('path')
      expect(service.text).to eq('')
      expect(mock_logger).to have_received(:warn).with('Text is not UTF-8 and cannot be used')
    end
  end
end
