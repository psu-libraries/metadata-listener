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
end
